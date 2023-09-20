class Comment < ApplicationRecord
  belongs_to :user, optional: true
  belongs_to :spot

  validates :content, presence: true, length: { maximum: 65_535 }
end
