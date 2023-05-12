class UserKeyword < ApplicationRecord
  belongs_to :user
  belongs_to :keyword

  validates :keyword, uniqueness: true
end
