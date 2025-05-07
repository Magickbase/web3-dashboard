module Stripe
  class CheckoutSessionsController < ApplicationController
    def index

    end

    def create
      json = CheckoutSessions::Create.run!(checkout_session_params)
      render json:
    end

    def expire

    end

    private

    def checkout_session_params
      params.permit(:price, :quantity, :customer_email, :success_url)
    end
  end
end
