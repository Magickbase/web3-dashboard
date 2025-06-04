ActiveAdmin.register ApiCall do
  # Specify parameters which should be permitted for assignment
  permit_params :user_id, :request_uid, :api_key, :route, :http_status, :error_code, :response_time_ms, :chain, :credits_used, :created, :synced, :source

  # or consider:
  #
  # permit_params do
  #   permitted = [:user_id, :request_uid, :api_key, :route, :http_status, :error_code, :response_time_ms, :chain, :credits_used, :created, :synced, :source]
  #   permitted << :other if params[:action] == 'create' && current_user.admin?
  #   permitted
  # end

  # For security, limit the actions that should be available
  actions :index, :show

  # Add or remove filters to toggle their visibility
  filter :id
  filter :user
  filter :request_uid
  filter :api_key
  filter :route
  filter :http_status
  filter :error_code
  filter :response_time_ms
  filter :chain
  filter :credits_used
  filter :created
  filter :synced
  filter :source

  # Add or remove columns to toggle their visibility in the index action
  index do
    selectable_column
    id_column
    column :user
    column :request_uid
    column :api_key
    column :route
    column :http_status
    column :error_code
    column :response_time_ms
    column :chain
    column :credits_used
    column :created
    column :synced
    column :source
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
      row :chain
      row :credits_used
      row :created
      row :synced
      row :source
      row :created_at
      row :updated_at
    end
  end
end
