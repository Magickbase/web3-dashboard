module CheckoutSessions
  class Destroy < ActiveInteraction::Base
    object :user
    string :session_uid

    def execute
      session = user.stripe_checkout_sessions.find_by(session_uid:)
      raise StripeCheckoutSessionNotFoundError unless session

      Stripe::Checkout::Session.expire(session_uid)
    rescue Stripe::StripeError => e
      raise ApiError::StripeRequestError.new(e.message)
    rescue ActiveRecord::RecordInvalid, ArgumentError => e
      raise ApiError::ActiveRecordError.new(e.message)
    end
  end
end
