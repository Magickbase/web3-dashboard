class User < ApplicationRecord
  has_many :stripe_checkout_sessions
  has_many :stripe_subscriptions
end
