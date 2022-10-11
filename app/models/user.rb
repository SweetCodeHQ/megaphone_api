class User < ApplicationRecord
  has_many :user_entities, dependent: :destroy
  has_many :entities, through: :user_entities
  has_many :topics, dependent: :destroy
  has_many :user_keywords, dependent: :destroy
  has_many :keywords, through: :user_keywords

  validates_presence_of :email
  validates :email, uniqueness: true
end
