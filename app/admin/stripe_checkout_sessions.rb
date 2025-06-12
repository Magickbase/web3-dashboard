ActiveAdmin.register StripeCheckoutSession do
  menu parent: "Stripe"
  actions :all, except: %i[new edit destroy]

  filter :user_subject, as: :string
  filter :session_uid
  filter :status
  filter :subscription_uid

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
    column :session_uid
    column :amount_subtotal
    column :amount_total
    column :status
    column :customer_uid
    column :created
    column :expires_at
    column :subscription_uid
    column :created_at
    column :updated_at
    actions
  end

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
      row :url do |record|
        div style: "word-break: break-all; white-space: normal; max-width: 600px;" do
          record.url
        end
      end
      row :subscription_uid
      row :created_at
      row :updated_at
    end
  end
end
