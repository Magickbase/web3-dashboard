class StripeCheckoutSessionSerializer
  include JSONAPI::Serializer

  set_id :session_id
  attributes :amount_subtotal, :amount_total, :created, :expires_at, :url
end
