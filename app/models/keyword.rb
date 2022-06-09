class Keyword < ApplicationRecord
  has_many :market_keywords
  has_many :markets, through: :market_keywords
  
  validates_presence_of :word
  validates :word, uniqueness: true
end
