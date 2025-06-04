ActiveAdmin.register StripeCheckoutSession do
  # Specify parameters which should be permitted for assignment
  permit_params :user_id, :session_uid, :amount_subtotal, :amount_total, :status, :customer_uid, :created, :expires_at, :url, :subscription_uid

  # or consider:
  #
  # permit_params do
  #   permitted = [:user_id, :session_uid, :amount_subtotal, :amount_total, :status, :customer_uid, :created, :expires_at, :url, :subscription_uid]
  #   permitted << :other if params[:action] == 'create' && current_user.admin?
  #   permitted
  # end

  # For security, limit the actions that should be available
  actions :all, except: %i[new edit destroy]

  # Add or remove filters to toggle their visibility
  filter :id
  filter :user
  filter :session_uid
  filter :amount_subtotal
  filter :amount_total
  filter :status
  filter :customer_uid
  filter :created
  filter :expires_at
  filter :url
  filter :subscription_uid
  filter :created_at
  filter :updated_at

  # Add or remove columns to toggle their visibility in the index action
  index do
    selectable_column
    id_column
    column :user
    column :session_uid
    column :amount_subtotal
    column :amount_total
    column :status
    column :customer_uid
    column :created
    column :expires_at
    column :url
    column :subscription_uid
    column :created_at
    column :updated_at
    actions
  end

  # Add or remove rows to toggle their visibility in the show action
  show do
    attributes_table_for(resource) do
      row :id
      row :user
      row :session_uid
      row :amount_subtotal
      row :amount_total
      row :status
      row :customer_uid
      row :created
      row :expires_at
      row :url
      row :subscription_uid
      row :created_at
      row :updated_at
    end
  end
end
