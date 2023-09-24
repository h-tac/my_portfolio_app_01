class User < ApplicationRecord
  authenticates_with_sorcery!

  has_many :spots
  has_many :comments, dependent: :nullify
  has_many :favorites, dependent: :destroy
  has_many :favorite_spots, through: :favorites, source: :spot

  enum role: { general: 0, admin: 1 }

  validates :name, presence: true, length: { maximum: 255 }
  validates :email, presence: true, uniqueness: true
  validates :password, presence: true, length: { minimum: 8 }, format: { with: /\A[a-zA-Z0-9]+\z/ }, confirmation: true, on: :create

  def favorite(spot)
    favorite_spots << spot
  end

  def unfavorite(spot)
    favorite_spots.delete(spot)
  end

  def favorite?(spot)
    favorite_spots.include?(spot)
  end

  def admin?
    role == 'admin'
  end
end
