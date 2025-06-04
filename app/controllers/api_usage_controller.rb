class ApiUsageController < ApplicationController
  before_action :authenticate_user!

  def show
    render json: ApiUsage::Show.run!(user: current_user, indicator: params[:id])
  end
end
