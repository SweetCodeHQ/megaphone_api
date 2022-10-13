class UserKeyword < ApplicationRecord
  belongs_to :user
  belongs_to :keyword

  validates_uniqueness_of :user_id
end
