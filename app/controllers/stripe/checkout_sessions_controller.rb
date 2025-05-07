module Stripe
  class CheckoutSessionsController < ApplicationController
    def index

    end

    def create
      render json: CheckoutSessions::Create.run!(checkout_session_params)
    end

    def expire

    end

    private

    def checkout_session_params
      params.permit(:price, :quantity, :customer_email, :success_url)
    end
  end
end
