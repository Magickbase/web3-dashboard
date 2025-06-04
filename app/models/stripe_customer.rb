class StripeCustomer < ApplicationRecord
  belongs_to :user
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
