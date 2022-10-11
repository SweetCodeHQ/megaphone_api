class Keyword < ApplicationRecord
  has_many :market_keywords
  has_many :markets, through: :market_keywords
  
  has_many :user_keywords
  has_many :users, through: :user_keywords

  validates_presence_of :word
  validates :word, uniqueness: { case_sensitive: false }
end
