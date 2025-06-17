module Webhooks
  class Subscription < BaseInteraction
    attr_reader :strip_subscription

    def handle
      subscription_uid = event.data.object.id
      obj = Stripe::Subscription.retrieve(subscription_uid)

      case event.type
      when "customer.subscription.created"
        handle_subscription_created(obj)
      when "customer.subscription.updated"
        handle_subscription_updated(obj)
      when "customer.subscription.deleted"
        handle_subscription_deleted(obj)
      else
        Rails.logger.warn "Unhandled stripe subscription event: #{event.inspect}"
      end
    end

    private

    def handle_subscription_created(obj)
      return if StripeSubscription.exists?(subscription_uid: obj.id)

      checkout_session = StripeCheckoutSession.find_by(subscription_uid: obj.id)
      unless checkout_session
        raise "Missing checkout session for subscription #{obj.id}"
      end

      item = obj.items.data[0]

      ApplicationRecord.transaction do
        StripeSubscription.create!(
          user_id: checkout_session.user_id,
          subscription_uid: obj.id,
          customer_uid: obj.customer,
          current_period_start: item.current_period_start,
          current_period_end: item.current_period_start,
          status: obj.status,
          created: obj.created,
          price_uid: item.price.id,
        )

        # 订阅成功后重置用户 credits 数量
        price = checkout_session.stripe_subscription.stripe_price
        checkout_session.user.update!(
          total_credits: price.credit_quota,
          remaining_credits: price.credit_quota,
        )
      end
    end

    def handle_subscription_updated(obj)
      subscription = StripeSubscription.find_by(subscription_uid: obj.id)
      raise "Subscription #{obj.id} not found" unless subscription

      item = obj.items.data[0]

      attributes = {
        current_period_start: item.current_period_start,
        cancel_at_period_end: obj.cancel_at_period_end,
        cancel_at: obj.cancel_at,
        canceled_at: obj.canceled_at,
        current_period_end: item.current_period_end,
        status: obj.status,
        price_uid: item.price.id,
      }

      subscription.update!(attributes)
    end

    def handle_subscription_deleted(obj)
      subscription = StripeSubscription.find_by(subscription_uid: obj.id)
      raise "Subscription #{obj.id} not found" unless subscription

      subscription.update!(status: obj.status)
    end
  end
end
