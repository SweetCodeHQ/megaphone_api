class Topic < ApplicationRecord
  belongs_to :user
  has_one :abstract, dependent: :destroy

  has_many :topic_keywords
  has_many :keywords, through: :topic_keywords

  validates_presence_of :text
  validates :text, uniqueness: true
end
