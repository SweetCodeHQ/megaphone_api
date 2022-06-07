class Entity < ApplicationRecord
  has_many :users, through: :user_entities
  validates_presence_of :url, :name

  validates :url, :name, uniqueness: true
end
