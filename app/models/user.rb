class User < ApplicationRecord
  authenticates_with_sorcery!

  has_many :spots
  has_many :comments
  has_many :favorites, dependent: :destroy
  has_many :favorite_spots, through: :favorites, source: :spot

  enum role: { general: 0, admin: 1 }

  def favorite(spot)
    favorite_spots << spot
  end

  def unfavorite(spot)
    favorite_spots.delete(spot)
  end

  def favorite?(spot)
    favorite_spots.include?(spot)
  end
end
