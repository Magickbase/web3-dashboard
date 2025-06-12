ActiveAdmin.register StripeCustomer do
  menu parent: "Stripe"
  actions :index

  filter :user_subject, as: :string
  filter :customer_uid
  filter :email

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
    column :customer_uid
    column :email
    column :created
    column :created_at
    column :updated_at
    actions
  end

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
end
