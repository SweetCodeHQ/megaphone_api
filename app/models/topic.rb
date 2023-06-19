class Topic < ApplicationRecord
  belongs_to :user
  has_one :abstract, dependent: :destroy

  has_many :topic_keywords
  has_many :keywords, through: :topic_keywords

  enum :content_type, {
    none_assigned: 0,
    blog_post: 1,
    extended_article: 2,
    technical_landing_page: 3,
    tutorial: 4,
    white_paper: 5,
    ebook: 6
  }

  validates_presence_of :text
  validates :text, uniqueness: true
end
