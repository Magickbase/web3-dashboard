ActiveAdmin.register StripeCustomer do
  menu parent: "Stripe"
  # Specify parameters which should be permitted for assignment
  permit_params :user_id, :customer_uid, :email, :created

  # or consider:
  #
  # permit_params do
  #   permitted = [:user_id, :customer_uid, :email, :created]
  #   permitted << :other if params[:action] == 'create' && current_user.admin?
  #   permitted
  # end

  # For security, limit the actions that should be available
  actions :index

  # Add or remove filters to toggle their visibility
  filter :id
  filter :user
  filter :customer_uid
  filter :email
  filter :created

  # Add or remove columns to toggle their visibility in the index action
  index do
    selectable_column
    id_column
    column :user
    column :customer_uid
    column :email
    column :created
    column :created_at
    column :updated_at
    actions
  end

  # Add or remove rows to toggle their visibility in the show action
  show do
    attributes_table_for(resource) do
      row :id
      row :user
      row :customer_uid
      row :email
      row :created
      row :created_at
      row :updated_at
    end
  end

  # Add or remove fields to toggle their visibility in the form
  form do |f|
    f.semantic_errors(*f.object.errors.attribute_names)
    f.inputs do
      f.input :user
      f.input :customer_uid
      f.input :email
      f.input :created
    end
    f.actions
  end
end
