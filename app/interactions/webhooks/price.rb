module Webhooks
  class Price < BaseInteraction
    def handle
      obj = event.data.object
      SyncStripeProducts.upsert_price(obj)
    end
  end
end
