module Webhooks
  class CheckoutSession < BaseInteraction
    def handle
      obj = event.data.object

      user_id = obj.dig(:metadata, :user_id)
      raise "Missing user_id in metadata" unless user_id

      user = User.find_by(id: user_id)
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
      session.update!(
        status: obj.status,
        customer_uid: obj.customer,
        subscription_uid: obj.subscription,
      )

      user.update!(
        total_credits: 100_000,
        remaining_credits: 100_000,
      ) # TODO: use dynamic value or pricing logic

      build_stripe_customer!(user, obj.customer)
    end

    def build_stripe_customer!(user, customer_uid)
      user.stripe_customers.find_or_create_by!(customer_uid:) do |sc|
        customer = Stripe::Customer.retrieve(customer_uid)
        sc.email   = customer.email
        sc.created = customer.created
      end
    end
  end
end
