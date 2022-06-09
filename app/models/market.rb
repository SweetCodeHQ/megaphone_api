class Market < ApplicationRecord
  validates_presence_of :name

  validates :name, uniqueness: true
end
