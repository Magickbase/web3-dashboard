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
      when /^checkout.session\./
        Webhooks::CheckoutSession.run!(event:)
      when /^customer.subscription\./
        Webhooks::Subscription.run!(event:)
      when /^invoice\./
        Webhooks::Invoice.run!(event:)
      else
        Rails.logger.warn "unhandled event type: #{event.type}"
      end

      head :ok
    end
  end
end
