module CheckoutSessions
  class Create < ActiveInteraction::Base
    string :price
    string :success_url, default: "https://example.com/success"
    string :cancel_url, default: nil
    integer :quantity
    string :mode, default: "subscription"
    string :customer_email, default: nil

    def execute
      data = Stripe::Checkout::Session.create(payload)
      session = StripeCheckoutSession.create!(
        session_id: data.id,
        amount_subtotal: data.amount_subtotal,
        amount_total: data.amount_total,
        created: data.created,
        expires_at: data.expires_at,
        url: data.url,
        user_id: 1, # TODO: fix me
      )
      StripeCheckoutSessionSerializer.new(session).serializable_hash.to_json
    rescue Stripe::StripeError => e
      raise StripeRequestError.new(e.message)
    rescue ActiveRecord::RecordInvalid, ArgumentError => e
      puts e.message
    end

    private

    def payload
      req = { line_items: [{ price:, quantity: }], success_url:, mode: }
      req[:customer_email] = customer_email if customer_email
      req[:metadata] = { user_id: "1" }
      req
    end
  end
end
