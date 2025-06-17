class SyncStripeProducts
  def self.sync_all_products
    Stripe::Product.list(limit: 100).auto_paging_each do |product|
      upsert_product_with_prices(product)
    end
  end

  def self.upsert_product_with_prices(product)
    StripeProduct.upsert(
      {
        product_uid: product.id,
        name: product.name,
        description: product.description,
        active: product.active,
        default_price_uid: product.default_price,
        livemode: product.livemode,
        created: product.created,
        updated: product.updated,
        metadata: product.metadata.to_h,
      }, unique_by: :product_uid
    )

    upsert_prices_for_product(product.id)
  end

  def self.upsert_prices_for_product(product_uid)
    Stripe::Price.list(product: product_uid).auto_paging_each do |price|
      upsert_price(price)
    end
  end

  def self.upsert_price(price)
    StripePrice.upsert(
      {
        price_uid: price.id,
        product_uid: price.product,
        nickname: price.nickname,
        active: price.active,
        created: price.created,
        currency: price.currency,
        metadata: price.metadata.to_h,
        unit_amount: price.unit_amount,
        unit_amount_decimal: price.unit_amount_decimal,
        billing_type: price.type,
        livemode: price.livemode,
        recurring: price.recurring.to_h,
      }, unique_by: :price_uid
    )
  end
end
