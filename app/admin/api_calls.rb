ActiveAdmin.register ApiCall do
  actions :index, :show

  filter :user_subject, as: :string
  filter :api_key
  filter :route
  filter :synced
  filter :source

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
    column :api_key
    column :route
    column :response_time_ms
    column :credits_used
    column :created
    column :synced
    column :source
    column :input_data
    column :created_at
    column :updated_at
    actions
  end

  # Add or remove rows to toggle their visibility in the show action
  show do
    attributes_table_for(resource) do
      row :id
      row :user
      row :request_uid
      row :api_key
      row :route
      row :http_status
      row :error_code
      row :response_time_ms
      row :credits_used
      row :created
      row :synced
      row :source
      row :created_at
      row :updated_at
    end
  end
end
