class StripeSubscription < ApplicationRecord
  belongs_to :user

  enum :status, { active: 0 }
end
