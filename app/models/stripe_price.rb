# https://docs.stripe.com/currencies?presentment-currency=IT
# stripe 的价格都是以货币最小单位返回
class StripePrice < ApplicationRecord
  belongs_to :stripe_product, foreign_key: :product_uid, primary_key: :product_uid

  def credit_quota
    metadata["credit_quota"]
  end
end

# == Schema Information
#
# Table name: stripe_prices
#
#  id                  :bigint           not null, primary key
#  active              :boolean
#  billing_type        :string
#  created             :integer
#  currency            :string
#  livemode            :boolean          default(FALSE)
#  metadata            :jsonb
#  nickname            :string
#  price_uid           :string
#  product_uid         :string
#  recurring           :jsonb
#  unit_amount         :integer
#  unit_amount_decimal :string
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#
# Indexes
#
#  index_stripe_prices_on_price_uid  (price_uid) UNIQUE
#
