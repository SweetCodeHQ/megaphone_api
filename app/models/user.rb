class User < ApplicationRecord
  has_many :user_entities
  has_many :entities, through: :user_entities
  has_many :topics
  
  validates_presence_of :email
  validates :email, uniqueness: true
end
