ActiveAdmin.register User do
  actions :index, :show
  filter :subject

  index do
    selectable_column
    id_column
    column :subject
    column :total_credits
    column :remaining_credits
    column :created_at
    column :updated_at
    actions
  end

  show do
    attributes_table_for(resource) do
      row :id
      row :subject
      row :total_credits
      row :remaining_credits
      row :created_at
      row :updated_at
    end
  end

  form do |f|
    f.semantic_errors(*f.object.errors.attribute_names)
    f.inputs do
      
    end
    f.actions
  end
end
