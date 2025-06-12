ActiveAdmin.register StripeInvoice do
  menu parent: "Stripe"
  actions :index, :show

  filter :invoice_uid
  filter :billing_reason
  filter :customer_uid
  filter :subscription_uid
  filter :status

  index do
    selectable_column
    id_column
    column :invoice_uid
    column :amount_due
    column :billing_reason
    column :created
    column :customer_uid
    column :hosted_invoice_url do |record|
      if record.hosted_invoice_url.present?
        link_to "View Invoice", record.hosted_invoice_url, target: "_blank", rel: "noopener", class: "button"
      else
        status_tag "No Invoice", :warning
      end
    end
    column :subscription_uid
    column :status
    column :created_at
    column :updated_at
    actions
  end

  # Add or remove rows to toggle their visibility in the show action
  show do
    attributes_table_for(resource) do
      row :id
      row :invoice_uid
      row :amount_due
      row :billing_reason
      row :created
      row :customer_uid
      row :hosted_invoice_url
      row :subscription_uid
      row :status
      row :created_at
      row :updated_at
    end
  end
end
