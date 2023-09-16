class SpotsPump < ApplicationRecord
  belongs_to :spot
  belongs_to :pump

  validates :spot_id, uniqueness: { scope: :pump_id }
end
