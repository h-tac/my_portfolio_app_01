class SpotsController < ApplicationController
  skip_before_action :require_login, except: %i[destroy list favorites]

  def index
    @q = Spot.ransack(params[:q])
    @spots = @q.result(distinct: true).page(params[:page]).order(created_at: :desc)
  end

  def show
    @spot = Spot.find(params[:id])
    @comment = Comment.new
    @comments = @spot.comments.order(created_at: :asc)
  end

  def new
    @spot = Spot.new

    @pumps = Pump.all
    @valves = Valve.all

    @lat = params[:lat]
    @lng = params[:lng]
    result = Geocoder.search([@lat, @lng]).first

    address = result.address # 住所全体 (郵便番号、国名を含む)

    @prefecture = extract_address_component(result, 'administrative_area_level_1') # 都道府県

    ward = extract_address_component(result, 'administrative_area_level_2') # 郡
    city = extract_address_component(result, 'locality') # 市区町村 (区は東京都の特別区)
    if ward
      @city = "#{ward}#{city}" # 郡と町村を結合
    else
      @city = city # 郡がない場合は市または特別区のみ
    end

    # 住所全体から郵便番号、国名、都道府県、市区町村を取り除く
    postal_code = extract_address_component(result, 'postal_code') # 郵便番号
    @country = extract_address_component(result, 'country') # 国名
    [postal_code, @country, @prefecture, @city].compact.each do |item|
      address.gsub!(/#{item}/, '')
    end
    @address_detail = address.gsub(/、〒\s*/, '').strip

    @full_address = "#{@prefecture}#{@city}#{@address_detail}" # 住所全体 (郵便番号、国名を含まない)
  end

  def create
    params_without_country = spot_params.except(:country)
    @spot = Spot.new(params_without_country)
    @spot.user_id = current_user.id if current_user

    if spot_params[:country] == '日本' && @spot.save
      flash[:success] = t('helpers.flash.spot.register.success')
      redirect_to spot_path(@spot)
    else
      @pumps = Pump.all
      @valves = Valve.all

      @prefecture = @spot.address_prefecture
      @city = @spot.address_city
      @address_detail = @spot.address_detail
      @full_address = @spot.decorate.full_address
      @lat = @spot.latitude
      @lng = @spot.longitude
      @country = spot_params[:country]

      case 
      when @country != '日本'
        flash.now[:danger] = t('helpers.flash.spot.register.japan_only')
      when @spot.errors.include?(:address_detail)
        flash.now[:danger] = t('helpers.flash.spot.register.invalid_address')
      when @spot.errors.include?(:latitude)
        flash.now[:danger] = t('helpers.flash.spot.register.overlap')
      else
        flash.now[:danger] = t('helpers.flash.spot.register.failure')
      end
      render :new
    end
  end

  def edit
    @spot = Spot.find(params[:id])

    @pumps = Pump.all
    @valves = Valve.all
  end

  def update
    @spot = Spot.find(params[:id])

    if @spot.update(spot_params)
      flash[:success] = t('helpers.flash.spot.update.success')
      redirect_to spot_path(@spot)
    else
      @pumps = Pump.all
      @valves = Valve.all

      flash.now[:danger] = t('helpers.flash.spot.update.failure')
      render :edit
    end
  end

  def destroy
    @spot = Spot.find(params[:id])
    @spot.destroy!
    flash[:success] = t('helpers.flash.spot.destroy')
    redirect_to spots_path
  end

  def list
    @spots = current_user.spots.page(params[:page]).order(created_at: :desc)
  end

  def favorites
    @spots = Spot.joins(:favorites).where(favorites: { user_id: current_user.id }).order('favorites.created_at DESC').page(params[:page])
  end

  def search
    @q = Spot.ransack(params[:q])

    @pumps = Pump.all
    @valves = Valve.all
  end

  private

  def extract_address_component(result, type)
    component = result.data['address_components'].find { |c| c['types'].include?(type) }
    component['long_name'] if component
  end

  def spot_params
    allowed_params = params.require(:spot).permit(
      :name,
      :fee,
      :opening_time,
      :closing_time,
      :address_prefecture,
      :address_city,
      :address_detail,
      :latitude,
      :longitude,
      :country,
      spots_pumps_attributes: [:pump_id, :id, :_destroy],
      spots_valves_attributes: [:valve_id, :id, :_destroy]
    )
    allowed_params[:fee] = allowed_params[:fee].to_i
    allowed_params
  end
end
