class SpotDecorator < ApplicationDecorator
  delegate_all

  def full_address
    "#{object.address_prefecture}#{object.address_city}#{object.address_detail}"
  end
end
