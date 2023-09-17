class Spot < ApplicationRecord
  has_many :spots_pumps, dependent: :destroy
  has_many :spots_valves, dependent: :destroy
  has_many :pumps, through: :spots_pumps
  has_many :valves, through: :spots_valves

  accepts_nested_attributes_for :spots_pumps, allow_destroy: true
  accepts_nested_attributes_for :spots_valves, allow_destroy: true

  enum fee: { free: 0, paid: 1 }

  validates :name, presence: true, length: { maximum: 255 }
  validates :fee, presence: true, inclusion: { in: Spot.fees.keys }
  validates :address_prefecture, presence: true
  validates :address_city, presence: true
  validates :address_detail, presence: true, uniqueness: true
  validates :latitude, presence: true, uniqueness: { scope: :longitude }
  validates :longitude, presence: true
  validate :must_have_at_least_one_pump
  validate :must_have_at_least_one_valve

  private

  def must_have_at_least_one_pump
    errors.add(:spots_pumps, '空気入れの動力を一つ以上選択してください') if spots_pumps.blank?
  end

  def must_have_at_least_one_valve
    errors.add(:spots_valves, 'バルブの形状を一つ以上選択してください') if spots_valves.blank?
  end
end
