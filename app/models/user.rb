class User < ApplicationRecord
  has_many :stripe_checkout_sessions
  has_many :stripe_subscriptions
end

# == Schema Information
#
# Table name: users
#
#  id         :bigint           not null, primary key
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
