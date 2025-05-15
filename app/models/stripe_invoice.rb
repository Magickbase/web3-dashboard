class StripeInvoice < ApplicationRecord
  enum :status, {
    draft: "draft",
    open: "open",
    paid: "paid",
    void: "void",
    uncollectible: "uncollectible",
  }
end
