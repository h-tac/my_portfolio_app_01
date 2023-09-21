class FavoritesController < ApplicationController
  def create
    spot = Spot.find(params[:spot_id])
    current_user.favorite(spot)
    redirect_to spots_path
  end

  def destroy
    current_user.unfavorite(Favorite.find(params[:id]).spot)
    # spot_id = Favorite.find(params[:id]).spot.id
    # @spot = Spot.find(spot_id)
    redirect_to spots_path
  end
end
