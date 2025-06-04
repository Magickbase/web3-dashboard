class StripeCheckoutSession < ApplicationRecord
  belongs_to :user

  enum :status, { open: "open", complete: "complete", expired: "expired" }

  def self.ransackable_associations(auth_object = nil)
    ["user"]
  end

  def self.ransackable_attributes(auth_object = nil)
    ["amount_subtotal", "amount_total", "created", "created_at", "customer_uid", "expires_at", "id", "session_uid", "status", "subscription_uid", "updated_at", "url", "user_id"]
  end
end

# == Schema Information
#
# Table name: stripe_checkout_sessions
#
#  id               :bigint           not null, primary key
#  amount_subtotal  :decimal(30, )
#  amount_total     :decimal(30, )
#  created          :integer
#  customer_uid     :string
#  expires_at       :integer
#  session_uid      :string
#  status           :string
#  subscription_uid :string
#  url              :text
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  user_id          :integer          not null
#
# Indexes
#
#  index_stripe_checkout_sessions_on_user_id  (user_id)
#
