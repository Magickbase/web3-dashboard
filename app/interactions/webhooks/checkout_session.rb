module Webhooks
  class CheckoutSession < BaseInteraction
    def handle
      session_uid = event.data.object.id
      obj = Stripe::Checkout::Session.retrieve(session_uid)

      user = User.find_by(id: obj.metadata[:user_id])
      raise "User #{user_id} not found" unless user

      session = user.stripe_checkout_sessions.find_by(session_uid: obj.id)
      raise "CheckoutSession #{obj.id} not found" unless session

      case event.type
      when "checkout.session.completed"
        handle_completed(session, user, obj)
      when "checkout.session.expired"
        session.update!(status: obj.status)
      else
        Rails.logger.info "Unhandled stripe checkout session event: #{event.inspect}"
      end
    end

    private

    def handle_completed(session, user, obj)
      ApplicationRecord.transaction do
        session.update!(
          status: obj.status,
          customer_uid: obj.customer,
          subscription_uid: obj.subscription,
        )

        # checkout session 和 subscription 同步顺序有差异，确保 subscription 及时同步到
        if obj.subscription.present? && session.stripe_subscription.nil?
          sync_subscription!(obj.subscription, user)
        end

        reset_user_credits!(user, session)
        ensure_stripe_customer(user, obj.customer)
      end
    end

    def sync_subscription!(subscription_uid, user)
      subscription = Stripe::Subscription.retrieve(subscription_uid)
      item = subscription.items.data.first

      StripeSubscription.create!(
        user_id: user.id,
        subscription_uid: subscription.id,
        customer_uid: subscription.customer,
        current_period_start: item.current_period_start,
        current_period_end: item.current_period_end,
        status: subscription.status,
        created: subscription.created,
        price_uid: item.price.id,
      )
    end

    def reset_user_credits!(user, session)
      credit_quota = session.stripe_price.credit_quota
      CreditsService.new(user).reset_credits!(credit_quota)
    end

    def ensure_stripe_customer(user, customer_uid)
      user.stripe_customers.find_or_create_by!(customer_uid:) do |sc|
        customer = Stripe::Customer.retrieve(customer_uid)
        sc.email   = customer.email
        sc.created = customer.created
      end
    end
  end
end
