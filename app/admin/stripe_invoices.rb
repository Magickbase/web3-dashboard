ActiveAdmin.register StripeInvoice do
  # Specify parameters which should be permitted for assignment
  permit_params :invoice_uid, :amount_due, :billing_reason, :created, :customer_uid, :hosted_invoice_url, :subscription_uid, :status

  # or consider:
  #
  # permit_params do
  #   permitted = [:invoice_uid, :amount_due, :billing_reason, :created, :customer_uid, :hosted_invoice_url, :subscription_uid, :status]
  #   permitted << :other if params[:action] == 'create' && current_user.admin?
  #   permitted
  # end

  # For security, limit the actions that should be available
  actions :all, except: %i[new edit destroy]

  # Add or remove filters to toggle their visibility
  filter :id
  filter :invoice_uid
  filter :amount_due
  filter :billing_reason
  filter :created
  filter :customer_uid
  filter :hosted_invoice_url
  filter :subscription_uid
  filter :status
  filter :created_at
  filter :updated_at

  # Add or remove columns to toggle their visibility in the index action
  index do
    selectable_column
    id_column
    column :invoice_uid
    column :amount_due
    column :billing_reason
    column :created
    column :customer_uid
    column :hosted_invoice_url
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

  # Add or remove fields to toggle their visibility in the form
  form do |f|
    f.semantic_errors(*f.object.errors.attribute_names)
    f.inputs do
      f.input :invoice_uid
      f.input :amount_due
      f.input :billing_reason
      f.input :created
      f.input :customer_uid
      f.input :hosted_invoice_url
      f.input :subscription_uid
      f.input :status
    end
    f.actions
  end
end
