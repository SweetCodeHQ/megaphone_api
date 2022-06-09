class Keyword < ApplicationRecord
  validates_presence_of :word

  validates :word, uniqueness: true
end
