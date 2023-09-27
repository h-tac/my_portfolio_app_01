class HomeController < ApplicationController
  skip_before_action :require_login

  def index; end

  def spots_data
    spots = Spot.all
    render json: spots
  end
end
