class StripeCheckoutSessionSerializer
  include JSONAPI::Serializer

  set_id :session_uid
  attributes :amount_subtotal, :amount_total, :created, :expires_at, :url, :status, :subscription_uid, :customer_uid
end
