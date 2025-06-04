class StripeInvoice < ApplicationRecord
  enum :status, {
    draft: "draft",
    open: "open",
    paid: "paid",
    void: "void",
    uncollectible: "uncollectible",
  }

  def self.ransackable_attributes(auth_object = nil)
    ["amount_due", "billing_reason", "created", "created_at", "customer_uid", "hosted_invoice_url", "id", "invoice_uid", "status", "subscription_uid", "updated_at"]
  end
end

# == Schema Information
#
# Table name: stripe_invoices
#
#  id                 :bigint           not null, primary key
#  amount_due         :integer
#  billing_reason     :string
#  created            :integer
#  customer_uid       :string
#  hosted_invoice_url :text
#  invoice_uid        :string
#  status             :string
#  subscription_uid   :string
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#
# Indexes
#
#  index_stripe_invoices_on_invoice_uid  (invoice_uid) UNIQUE
#
