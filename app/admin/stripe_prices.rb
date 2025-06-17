ActiveAdmin.register StripePrice do
  menu parent: "Stripe"
  actions :index, :show

  filter :price_uid
  filter :product_uid
  filter :active
  filter :currency
  filter :billing_type

  index do
    selectable_column
    id_column
    column :nickname
    column :price_uid
    column :product_uid
    column :active
    column :created
    column :currency
    column :credit_quota
    column :unit_amount
    column :unit_amount_decimal
    column :billing_type
    column :livemode
    column :interval do |record|
      record.recurring["interval"]
    end
    actions
  end

  # Add or remove rows to toggle their visibility in the show action
  show do
    attributes_table_for(resource) do
      row :id
      row :nickname
      row :price_uid
      row :product_uid
      row :active
      row :created
      row :currency
      row :metadata
      row :unit_amount
      row :unit_amount_decimal
      row :billing_type
      row :livemode
      row :recurring
      row :created_at
      row :updated_at
    end
  end
end
