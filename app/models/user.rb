class User < ApplicationRecord
  has_many :stripe_customers
  has_many :stripe_invoices, through: :stripe_customers
  has_many :stripe_checkout_sessions
  has_many :api_calls
  has_many :stripe_subscriptions do
    def effective
      where(status: %w[active trialing past_due]).first
    end
  end
end

# == Schema Information
#
# Table name: users
#
#  id                :bigint           not null, primary key
#  remaining_credits :bigint           default(0)
#  subject           :string
#  total_credits     :bigint           default(0)
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#
