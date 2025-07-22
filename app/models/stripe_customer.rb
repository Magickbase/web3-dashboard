class StripeCustomer < ApplicationRecord
  belongs_to :user
  has_many :stripe_invoices, foreign_key: :customer_uid, primary_key: :customer_uid
end

# == Schema Information
#
# Table name: stripe_customers
#
#  id           :bigint           not null, primary key
#  created      :integer
#  customer_uid :string
#  email        :string
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  user_id      :integer          not null
#
