module Webhooks
  class CheckoutSession < ActiveInteraction::Base
    object :event, class: Stripe::Event

    def execute
      obj = event.data.object
      user = User.find_by(id: obj.metadata[:user_id])
      unless user
        Rails.logger.error "user (#{obj.metadata[:user_id]}) not found: #{obj.inspect}"
        return
      end

      session = user.stripe_checkout_sessions.find_by(session_uid: obj.id)
      unless session
        Rails.logger.error "stripe checkout session (#{obj.id}) not found: #{obj.inspect}"
        return
      end

      case event.type
      when "checkout.session.completed"
        session.update!(status: obj.status, customer_uid: obj.customer, subscription_uid: obj.subscription)
        user.update!(total_credits: 100_000, remaining_credits: 100_000) # fix me
        build_stripe_customer!(user, obj.customer)
      when "checkout.session.expired"
        session.update!(status: obj.status)
      else
        Rails.logger.info "unhandled stripe checkout session event: #{event.inspect}"
      end
    end

    private

    def build_stripe_customer!(user, customer_uid)
      user.stripe_customers.find_or_create_by!(customer_uid:) do |sc|
        customer = Stripe::Customer.retrieve(customer_uid)
        sc.email   = customer.email
        sc.created = customer.created
      end
    end
  end
end
