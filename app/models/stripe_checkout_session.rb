class StripeCheckoutSession < ApplicationRecord
  belongs_to :user

  enum :status, { open: "open", complete: "complete", expired: "expired" }
end
