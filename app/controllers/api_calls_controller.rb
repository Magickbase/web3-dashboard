class ApiCallsController < ApplicationController
  def create
    ApiCalls::Create.run!(api_call_params.merge({ user: current_user }))

    head :ok
  end

  private

  def api_call_params
    params.permit(:api_key, :chain, :created, :credits_used, :error_code, :http_status, :path, :response_time_ms)
  end
end
