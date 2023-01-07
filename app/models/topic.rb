class Topic < ApplicationRecord
  belongs_to :user
  has_one :abstract, dependent: :destroy

  validates_presence_of :text
  validates :text, uniqueness: true
end
