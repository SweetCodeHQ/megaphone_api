class Entity < ApplicationRecord
  has_many :user_entities
  has_many :users, through: :user_entities
  has_many :entity_markets
  has_many :markets, through: :entity_markets

  validates_presence_of :url, :name
  validates :url, :name, uniqueness: true
end
