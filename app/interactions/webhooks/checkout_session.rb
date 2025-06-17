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

        build_stripe_customer!(user, obj.customer)
      end
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
