module Stripe
  class WebhooksController < ApplicationController
    def callback
      payload = request.body.read
      sig_header = request.env["HTTP_STRIPE_SIGNATURE"]
      endpoint_secret = ENV.fetch("STRIPE_WEBHOOK_ENDPOINT_SECRET", nil)

      begin
        event = Stripe::Webhook.construct_event(payload, sig_header, endpoint_secret)
      rescue JSON::ParserError => e
        Rails.logger.error "Webhook JSON parse error: #{e.message}"
        return head :bad_request
      rescue Stripe::SignatureVerificationError => e
        # Invalid signature
        Rails.logger.error "Error verifying webhook signature: #{e.message}"
        return head :bad_request
      end

      # 为保证数据准确和完整，统一通过 Stripe API 的 retrieve 方法获取最新的完整 invoice, session 等对象，避免处理异常
      result =
        case event.type
        when /^checkout.session\./
          Webhooks::CheckoutSession.run(event:)
        when /^customer.subscription\./
          Webhooks::Subscription.run(event:)
        when /^invoice\./
          Webhooks::Invoice.run(event:)
        when /^product\./
          Webhooks::Product.run(event:)
        when /^price\./
          Webhooks::Price.run(event:)
        else
          Rails.logger.warn "unhandled event type: #{event.type}"
          nil
        end

      return head :bad_request if result&.invalid?

      head :ok
    end
  end
end
