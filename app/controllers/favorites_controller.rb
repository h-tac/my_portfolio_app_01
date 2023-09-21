class FavoritesController < ApplicationController
  def create
    @spot = Spot.find(params[:spot_id])
    current_user.favorite(@spot)
  end

  def destroy
    @spot = Favorite.find(params[:id]).spot
    current_user.unfavorite(@spot)
  end
end
