class StripeProductSerializer
  include JSONAPI::Serializer

  set_id :product_uid
  attributes :name, :description, :metadata

  attribute :stripe_prices, if: Proc.new { |record| record.price_on } do |object|
    object.active_prices.map do |price|
      {
        id: price.price_uid,
        billing_type: price.billing_type,
        currency: price.currency,
        metadata: price.metadata,
        nickname: price.nickname,
        recurring: price.recurring,
        unit_amount: price.unit_amount,
        unit_amount_decimal: price.unit_amount_decimal,
      }
    end
  end
end
