ActiveAdmin.register StripeProduct do
  menu parent: "Stripe"
  actions :index, :show

  filter :product_uid
  filter :active

  index do
    selectable_column
    id_column
    column :name
    column :description
    column :product_uid
    column :active
    column :default_price_uid
    column :livemode
    column :created
    column :updated
    column :price_on
    actions
  end

  show do
    attributes_table_for(resource) do
      row :id
      row :name
      row :description
      row :product_uid
      row :active
      row :default_price_uid
      row :livemode
      row :created
      row :updated
      row :metadata
    end

    tabs do
      tab :stripe_prices do
        table_for resource.stripe_prices do
          column :id
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
        end
      end
    end
  end
end
