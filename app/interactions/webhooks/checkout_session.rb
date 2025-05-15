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
      when "checkout.session.expired"
        session.update!(status: obj.status)
      else
        Rails.logger.info "unhandled stripe checkout session event: #{event.inspect}"
      end
    end
  end
end
