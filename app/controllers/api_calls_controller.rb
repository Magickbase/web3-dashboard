class ApiCallsController < ApplicationController
  before_action :authenticate_user!

  def index
    pagy, items = ApiCalls::Index.run!(user: current_user, pagy_params:)

    render json: ApiCallSerializer.new(items, meta: page_info(pagy)).serializable_hash
  end

  def create
    ApiCalls::Create.run!(api_call_params.merge({ user: current_user }))

    head :ok
  end

  private

  def api_call_params
    params.permit(:api_key, :chain, :created, :error_code,
                  :http_status, :response_time_ms, :route, :source, :request_uid)
  end
end
