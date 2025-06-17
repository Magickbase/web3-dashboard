module Webhooks
  class Invoice < BaseInteraction
    def handle
      invoice_uid = event.data.object.id
      obj = Stripe::Invoice.retrieve(invoice_uid)
      subscription_uid = obj.parent.subscription_details.subscription

      attrs = {
        invoice_uid: obj.id,
        amount_due: obj.amount_due,
        billing_reason: obj.billing_reason,
        created: obj.created,
        customer_uid: obj.customer,
        hosted_invoice_url: obj.hosted_invoice_url,
        subscription_uid:,
        status: obj.status,
      }

      StripeInvoice.upsert(attrs, unique_by: :invoice_uid)
    rescue StandardError => e
      errors.add(:base, "Invoice event processing failed: #{e.message}")
      raise
    end
  end
end
