module Stripe
  class WebhooksController < ApplicationController
    def callback
      begin
        event = Stripe::Event.construct_from(
          JSON.parse(params.to_json, symbolize_names: true),
        )
      rescue JSON::ParserError => e
        Rails.logger.error e.message
        status 400
        return
      end

      case event.type
      when "checkout.session.completed"
        session_id = event.data.object.id
        session =
      end

      # https://docs.stripe.com/webhooks?snapshot-or-thin=snapshot
    end

    private

    def find_checkout_session(session_id)
      StripeCheckout
    end
  end
end
