class SpotsController < ApplicationController
  def new
    lat = params[:lat]
    lng = params[:lng]
    @full_address = Geocoder.search([lat, lng]).first.address
  end
end
