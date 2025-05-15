module Webhooks
  class Invoice < ActiveInteraction::Base
    object :event, class: Stripe::Event

    def execute
      obj = event.data.object
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
    end
  end
end
