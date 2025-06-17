class StripeProduct < ApplicationRecord
  has_many :stripe_prices, foreign_key: :product_uid, primary_key: :product_uid
  has_many :active_prices, -> { where(active: true) },
           class_name: "StripePrice",
           foreign_key: :product_uid,
           primary_key: :product_uid

  def price_on
    val = metadata["price_on"]
    return true unless val

    ActiveModel::Type::Boolean.new.cast(val)
  end
end

# == Schema Information
#
# Table name: stripe_products
#
#  id                :bigint           not null, primary key
#  active            :boolean          default(TRUE)
#  created           :integer
#  default_price_uid :string
#  description       :text
#  livemode          :boolean          default(FALSE)
#  metadata          :jsonb
#  name              :string
#  product_uid       :string
#  updated           :integer
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#
# Indexes
#
#  index_stripe_products_on_product_uid  (product_uid) UNIQUE
#
