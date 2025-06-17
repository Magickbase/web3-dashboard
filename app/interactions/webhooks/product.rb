module Webhooks
  class Product < BaseInteraction
    def handle
      obj = event.data.object
      SyncStripeProducts.upsert_product_with_prices(obj)
    end
  end
end
