class FavoritesController < ApplicationController
  def create
    @spot = Spot.find(params[:spot_id])
    current_user.favorite(@spot)
    respond_to do |format|
      format.html { redirect_to spots_path }
      format.js
    end
  end

  def destroy
    @spot = Favorite.find(params[:id]).spot
    current_user.unfavorite(@spot)
    respond_to do |format|
      format.html { redirect_to spots_path }
      format.js
    end
  end
end
