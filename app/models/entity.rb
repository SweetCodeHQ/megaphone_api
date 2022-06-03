class Entity < ApplicationRecord

  validates_presence_of :url, :name

  validates :url, :name, uniqueness: true
end
