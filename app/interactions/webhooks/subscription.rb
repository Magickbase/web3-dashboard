module Webhooks
  class Subscription < ActiveInteraction::Base
    object :event, class: Stripe::Event

    def execute
      obj = event.data.object

      case event.type
      when "customer.subscription.created"
        handle_subscription_created(obj)
      when "customer.subscription.updated"
        handle_subscription_updated(obj)
      when "customer.subscription.deleted"
        handle_subscription_deleted(obj)
      else
        Rails.logger.warn "unhandled stripe checkout session event: #{event.inspect}"
      end
    end

    private

    def handle_subscription_created(obj)
      return if StripeSubscription.exists?(subscription_uid: obj.id)

      checkout_session = StripeCheckoutSession.find_by(subscription_uid: obj.id)
      unless checkout_session
        Rails.logger.error "stripe subscription (#{obj.id}) has no matching checkout session: #{obj.inspect}"
        return
      end

      StripeSubscription.create!(
        user_id: checkout_session.user_id,
        subscription_uid: obj.id,
        customer_uid: obj.customer,
        current_period_start: obj.current_period_start,
        current_period_end: obj.current_period_end,
        status: obj.status,
        created: obj.created,
      )
    end

    def handle_subscription_updated(obj)
      subscription = StripeSubscription.find_by(subscription_uid: obj.id)
      unless subscription
        Rails.logger.error "stripe checkout session (#{obj.id}) not found: #{obj.inspect}"
        return
      end

      subscription.update!(
        current_period_start: obj.current_period_start,
        cancel_at_period_end: obj.cancel_at_period_end,
        cancel_at: obj.cancel_at,
        canceled_at: obj.canceled_at,
        current_period_end: obj.current_period_end,
        status: obj.status,
      )
    end

    def handle_subscription_deleted(obj)
      subscription = StripeSubscription.find_by(subscription_uid: obj.id)
      unless subscription
        Rails.logger.error "stripe checkout session (#{obj.id}) not found: #{obj.inspect}"
        return
      end

      subscription.update!(status: obj.status)
    end
  end
end
