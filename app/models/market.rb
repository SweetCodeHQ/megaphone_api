class Market < ApplicationRecord
  has_many :entity_markets
  has_many :entities, through: :entity_markets

  has_many :market_keywords
  has_many :keywords, through: :market_keywords

  validates_presence_of :name
  validates :name, uniqueness: true
end
