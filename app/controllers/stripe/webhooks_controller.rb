module Stripe
  class WebhooksController < ApplicationController
    def callback
      payload = request.body.read

      begin
        event = Stripe::Event.construct_from(
          JSON.parse(payload, symbolize_names: true),
        )
      rescue JSON::ParserError => e
        Rails.logger.error "Webhook JSON parse error: #{e.message}"
        return head :bad_request
      end

      case event.type
      when "checkout.session.completed"
        handle_checkout_completed(event.data.object)
      when "checkout.session.expired"
        handle_checkout_expired(event.data.object)
      when "customer.subscription.created"
        handle_subscription_created(event.data.object)
      else
        Rails.logger.warn "Unhandled event type: #{event.type}"
      end

      head :ok
    end

    private

    def handle_checkout_completed(obj)
      session = StripeCheckoutSession.find_by(session_uid: obj.id)
      return unless session

      session.update!(status: obj.status, customer_uid: obj.customer)
    end

    def handle_checkout_expired(obj)
      session = StripeCheckoutSession.find_by(session_uid: obj.id)
      return unless session

      session.update!(status: obj.status)
    end

    def handle_subscription_created(obj)
      return if StripeSubscription.exists?(subscription_uid: obj.id)

      item = obj.items.data[0]

      StripeSubscription.create!(
        user_id: 1,
        subscription_uid: obj.id,
        price_uid: item.price.id,
        current_period_start: obj.current_period_start,
        current_period_end: obj.current_period_end,
        status: obj.status,
      )
    end
  end
end
