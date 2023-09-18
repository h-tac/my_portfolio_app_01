class SpotsValve < ApplicationRecord
  belongs_to :spot
  belongs_to :valve

  validates :spot_id, uniqueness: { scope: :valve_id }
end
