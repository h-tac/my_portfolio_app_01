class User < ApplicationRecord
  authenticates_with_sorcery!

  has_many :spots

  enum role: { general: 0, admin: 1 }
end
