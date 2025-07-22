class StripeInvoiceSerializer
  include JSONAPI::Serializer

  set_id :invoice_uid
  attributes :amount_due, :billing_reason, :created, :hosted_invoice_url, :status, :subscription_uid
end
