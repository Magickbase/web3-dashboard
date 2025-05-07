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
        obj = event.data.object
        session = StripeCheckoutSession.find_by(session_id: obj.id)
        return unless session

        session.update!(status: "completed", customer: obj.customer)
      end
    end
  end
end
