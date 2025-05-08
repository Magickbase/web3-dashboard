class StripeCheckoutSession < ApplicationRecord
  belongs_to :user

  enum :status, { open: 0, complete: 1, expired: 2 }
end
