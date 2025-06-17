module Stripe
  class ProductsController < ApplicationController
    def index
      scope = StripeProduct.where(active: true).includes(:active_prices)

      render json: StripeProductSerializer.new(scope).serializable_hash
    end
  end
end
