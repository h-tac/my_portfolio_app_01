class Favorite < ApplicationRecord
  belongs_to :user
  belongs_to :spot

  validates :user_id, presence: true, uniqueness: { scope: :spot_id }
  validates :spot_id, presence: true
end
