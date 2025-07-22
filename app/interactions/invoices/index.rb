module Invoices
  class Index < ActiveInteraction::Base
    include Pagy::Backend

    object :user
    hash :pagy_params, default: {}, strip: false

    def execute
      scope = user.stripe_invoices.order(created: :desc)
      pagy(scope, **pagy_params.symbolize_keys)
    end
  end
end
