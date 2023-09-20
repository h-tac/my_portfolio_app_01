class Spot < ApplicationRecord
  has_many :spots_pumps, dependent: :destroy
  has_many :spots_valves, dependent: :destroy
  has_many :pumps, through: :spots_pumps
  has_many :valves, through: :spots_valves
  belongs_to :user, optional: true

  accepts_nested_attributes_for :spots_pumps, allow_destroy: true
  accepts_nested_attributes_for :spots_valves, allow_destroy: true

  enum fee: { free: 0, paid: 1 }

  validates :name, presence: true, length: { maximum: 255 }
  validates :fee, presence: true, inclusion: { in: Spot.fees.keys }
  validates :address_prefecture, presence: true
  validates :address_city, presence: true
  validates :address_detail, presence: true, uniqueness: true, format: { with: /\p{Hiragana}+|\p{Katakana}+|\p{Han}+/ }
  validates :latitude, presence: true, uniqueness: { scope: :longitude }
  validates :longitude, presence: true
  validate :must_have_at_least_one_pump
  validate :must_have_at_least_one_valve
  validate :check_opening_and_closing_times

  private

  def must_have_at_least_one_pump
    if spots_pumps.reject(&:marked_for_destruction?).blank?
      errors.add(:spots_pumps, '空気入れの動力を一つ以上選択してください')
    end
  end

  def must_have_at_least_one_valve
    if spots_valves.reject(&:marked_for_destruction?).blank?
      errors.add(:spots_valves, 'バルブの形状を一つ以上選択してください')
    end
  end

  def check_opening_and_closing_times
    if opening_time.present? && closing_time.blank?
      errors.add(:closing_time, '営業開始時間を入力した場合は、営業終了時間も入力してください')
    elsif opening_time.blank? && closing_time.present?
      errors.add(:opening_time, '営業終了時間を入力した場合は、営業開始時間も入力してください')
    end
  end
end
