module Webhooks
  class Invoice < BaseInteraction
    def handle
      obj = event.data.object

      raise "Missing invoice id" if obj.id.blank?

      attrs = {
        invoice_uid: obj.id,
        amount_due: obj.amount_due,
        billing_reason: obj.billing_reason,
        created: obj.created,
        customer_uid: obj.customer,
        hosted_invoice_url: obj.hosted_invoice_url,
        subscription_uid: obj.subscription,
        status: obj.status,
      }

      StripeInvoice.upsert(attrs, unique_by: :invoice_uid)
    rescue StandardError => e
      errors.add(:base, "Invoice event processing failed: #{e.message}")
      raise
    end
  end
end
