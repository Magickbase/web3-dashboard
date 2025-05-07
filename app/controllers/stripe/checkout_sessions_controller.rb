module Stripe
  class CheckoutSessionsController < ApplicationController
    def create
      json = CheckoutSessions::Create.run!(checkout_session_params)
      render json:
    end

    private

    def checkout_session_params
      params.permit(:price, :quantity, :customer_email)
    end
  end
end
