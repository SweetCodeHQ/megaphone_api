class Topic < ApplicationRecord
  belongs_to :user

  validates_presence_of :text
  validates :text, uniqueness: true
end
