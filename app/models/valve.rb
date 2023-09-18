class Valve < ApplicationRecord
  has_many :spots_valves
  has_many :spots, through: :spots_valves

  validates :kind, presence: true, uniqueness: true
end
