class ApiUsageController < ApplicationController
  def show
    render json: ApiUsage::Show.run!(user: current_user, indicator: params[:id])
  end
end
