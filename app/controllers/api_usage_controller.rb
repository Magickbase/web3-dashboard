class ApiUsageController < ApplicationController
  before_action :authenticate_user!

  def show
    data = ApiUsage::Show.run!(user: current_user, indicator: params[:id])

    render json: { data: }
  end
end
