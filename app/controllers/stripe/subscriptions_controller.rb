module Stripe
  class SubscriptionsController < ApplicationController
    def show
      subscription = current_user.stripe_subscriptions.effective
      raise ApiError::StripeActiveSubscriptionNotFoundError unless subscription

      render json: StripeSubscriptionSerializer.new(subscription).serializable_hash
    end

    def update
      Subscriptions::Update.run!({ user: current_user, price: params[:price] })

      head :ok
    end

    def destroy
      subscription = current_user.stripe_subscriptions.effective
      raise ApiError::UncancelableStripeSubscriptionError unless subscription.cancelable?

      data = Stripe::Subscription.update(subscription.subscription_uid, cancel_at_period_end: true)
      subscription.update!(
        cancel_at: data.cancel_at,
        cancel_at_period_end: data.cancel_at_period_end,
        canceled_at: data.canceled_at,
      )

      render json: StripeSubscriptionSerializer.new(subscription).serializable_hash
    rescue Stripe::StripeError => e
      raise ApiError::StripeRequestError.new(e.message)
    rescue ActiveRecord::RecordInvalid, ArgumentError => e
      raise ApiError::ActiveRecordError.new(e.message)
    end
  end
end
