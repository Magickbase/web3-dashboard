module Stripe
  class CheckoutSessionsController < ApplicationController
    before_action :authenticate_user!, except: [:create]

    def index
      scope = current_user.stripe_checkout_sessions.order(created: :desc)
      pagy, items = pagy(scope, **pagy_params)

      render json: StripeCheckoutSessionSerializer.new(items, meta: page_info(pagy)).serializable_hash
    end

    def create
      authenticate_user!(register: true)

      render json: CheckoutSessions::Create.run!(
        checkout_session_params.merge(
          { user: current_user },
        ),
      )
    end

    def destroy
      CheckoutSessions::Destroy.run!({ user: current_user, session_uid: params[:session_uid] })

      head :ok
    end

    private

    def checkout_session_params
      params.permit(:price, :quantity, :customer_email, :success_url, :mode)
    end
  end
end
