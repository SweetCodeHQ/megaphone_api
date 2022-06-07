class UserEntity < ApplicationRecord
  belongs_to :user
  belongs_to :entity

  validates_uniqueness_of :user_id
end
