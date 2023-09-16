class Pump < ApplicationRecord
  has_many :spots_pumps
  has_many :spots, through: :spots_pumps

  validates :usage, presence: true, uniqueness: true
end
