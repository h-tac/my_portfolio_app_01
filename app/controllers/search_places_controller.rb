class SearchPlacesController < ApplicationController
  skip_before_action :require_login

  def index; end

  def create
    base_url = 'https://maps.googleapis.com/maps/api/geocode/json'
    address = CGI::escape(params[:place_name])
    api_key = ENV['GOOGLE_MAPS_SERVER_API_KEY']

    uri = URI("#{base_url}?address=#{address}&key=#{api_key}&language=ja")
    response = Net::HTTP.get(uri)
    result = JSON.parse(response)

    if result['status'] == 'OK' || result['status'] == 'ZERO_RESULTS'
      @searched_flag = true
      @places = result['results'].map do |res|
        {
          address: res['formatted_address'].gsub('日本、', '').gsub(/〒\d{3}-\d{4}/, '').strip,
          lat: res['geometry']['location']['lat'],
          lng: res['geometry']['location']['lng']
        }
      end
    else
      flash.now[:danger] = '地名の検索に失敗しました'
    end
  
    render :index
  end
end
