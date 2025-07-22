module Stripe
  class InvoicesController < ApplicationController
    before_action :authenticate_user!

    def index
      pagy, items = Invoices::Index.run!(user: current_user, pagy_params:)

      render json: StripeInvoiceSerializer.new(items, meta: page_info(pagy)).serializable_hash
    end
  end
end
