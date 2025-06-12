ActiveAdmin.register StripeSubscription do
  menu parent: "Stripe"
  actions :index, :show

  filter :user_subject, as: :string
  filter :subscription_uid
  filter :customer_uid
  filter :created
  filter :price_uid

  index do
    selectable_column
    id_column
    column :user do |record|
      if record.user&.subject.present?
        link_to record.user.subject, admin_user_path(record.user)
      elsif record.user
        link_to "User ##{record.user.id}", admin_user_path(record.user)
      end
    end
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
end
