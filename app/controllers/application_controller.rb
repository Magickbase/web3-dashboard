class ApplicationController < ActionController::API
  rescue_from BaseError, with: :handle_error

  def handle_error(error)
    render json: ApiErrorSerializer.new(error), status: :ok
  end
end
