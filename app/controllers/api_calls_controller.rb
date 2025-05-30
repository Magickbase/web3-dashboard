class ApiCallsController < ApplicationController
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
