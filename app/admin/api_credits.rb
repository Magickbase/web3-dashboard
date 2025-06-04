ActiveAdmin.register ApiCredit do
  # Specify parameters which should be permitted for assignment
  permit_params :route, :credit_cost, :description

  # or consider:
  #
  # permit_params do
  #   permitted = [:route, :credit_cost, :description]
  #   permitted << :other if params[:action] == 'create' && current_user.admin?
  #   permitted
  # end

  # For security, limit the actions that should be available
  actions :all, except: []

  # Add or remove filters to toggle their visibility
  filter :id
  filter :route
  filter :credit_cost
  filter :description
  filter :created_at
  filter :updated_at

  # Add or remove columns to toggle their visibility in the index action
  index do
    selectable_column
    id_column
    column :route
    column :credit_cost
    column "cached_credit_cost" do |c|
      ApiCreditCache.read(c.route)
    end
    column :description
    column :created_at
    column :updated_at
    actions
  end

  # Add or remove rows to toggle their visibility in the show action
  show do
    attributes_table_for(resource) do
      row :id
      row :route
      row :credit_cost
      row :description
      row :created_at
      row :updated_at
    end
  end

  # Add or remove fields to toggle their visibility in the form
  form do |f|
    f.semantic_errors(*f.object.errors.attribute_names)
    f.inputs do
      f.input :route, input_html: { disabled: true }
      f.input :credit_cost
      f.input :description
    end
    f.actions
  end
end
