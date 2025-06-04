ActiveAdmin.register StripeSubscription do
  # Specify parameters which should be permitted for assignment
  permit_params :user_id, :subscription_uid, :customer_uid, :current_period_start, :current_period_end, :cancel_at, :canceled_at, :cancel_at_period_end, :status, :created, :price_uid

  # or consider:
  #
  # permit_params do
  #   permitted = [:user_id, :subscription_uid, :customer_uid, :current_period_start, :current_period_end, :cancel_at, :canceled_at, :cancel_at_period_end, :status, :created, :price_uid]
  #   permitted << :other if params[:action] == 'create' && current_user.admin?
  #   permitted
  # end

  # For security, limit the actions that should be available
  actions :all, except: %i[new edit destroy]

  # Add or remove filters to toggle their visibility
  filter :id
  filter :user
  filter :subscription_uid
  filter :customer_uid
  filter :current_period_start
  filter :current_period_end
  filter :cancel_at
  filter :canceled_at
  filter :cancel_at_period_end
  filter :status
  filter :created
  filter :price_uid
  filter :created_at
  filter :updated_at

  # Add or remove columns to toggle their visibility in the index action
  index do
    selectable_column
    id_column
    column :user
    column :subscription_uid
    column :customer_uid
    column :current_period_start
    column :current_period_end
    column :cancel_at
    column :canceled_at
    column :cancel_at_period_end
    column :status
    column :created
    column :price_uid
    column :created_at
    column :updated_at
    actions
  end

  # Add or remove rows to toggle their visibility in the show action
  show do
    attributes_table_for(resource) do
      row :id
      row :user
      row :subscription_uid
      row :customer_uid
      row :current_period_start
      row :current_period_end
      row :cancel_at
      row :canceled_at
      row :cancel_at_period_end
      row :status
      row :created
      row :price_uid
      row :created_at
      row :updated_at
    end
  end

  # Add or remove fields to toggle their visibility in the form
  form do |f|
    f.semantic_errors(*f.object.errors.attribute_names)
    f.inputs do
      f.input :user
      f.input :subscription_uid
      f.input :customer_uid
      f.input :current_period_start
      f.input :current_period_end
      f.input :cancel_at
      f.input :canceled_at
      f.input :cancel_at_period_end
      f.input :status
      f.input :created
      f.input :price_uid
    end
    f.actions
  end
end
