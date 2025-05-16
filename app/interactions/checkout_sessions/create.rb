module CheckoutSessions
  class Create < ActiveInteraction::Base
    object :user
    string :price
    integer :quantity
    string :success_url, default: "https://example.com/success"
    string :cancel_url, default: nil
    string :mode, default: "subscription"
    string :customer_email, default: nil

    validate :validate_stripe_state!

    def execute
      data = Stripe::Checkout::Session.create(payload)
      session = StripeCheckoutSession.create!(
        user_id: user.id,
        session_uid: data.id,
        amount_subtotal: data.amount_subtotal,
        amount_total: data.amount_total,
        created: data.created,
        expires_at: data.expires_at,
        url: data.url,
        status: data.status,
      )
      StripeCheckoutSessionSerializer.new(session).serializable_hash.to_json
    rescue Stripe::StripeError => e
      raise ApiError::StripeRequestError.new(e.message)
    rescue ActiveRecord::RecordInvalid, ArgumentError => e
      raise ApiError::ActiveRecordError.new(e.message)
    end

    private

    def validate_stripe_state!
      raise ApiError::OpenStripeCheckoutSessionExistsError if user.stripe_checkout_sessions.open.exists?
      raise ApiError::ActiveStripeSubscriptionExistsError if user.stripe_subscriptions.active.exists?
    end

    def payload
      req = { line_items: [{ price:, quantity: }], success_url:, mode:, metadata: { user_id: user.id } }
      req[:customer_email] = customer_email if customer_email
      req
    end
  end
end
