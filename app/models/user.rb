class User < ApplicationRecord
  has_many :user_entities, dependent: :destroy
  has_many :entities, through: :user_entities
  has_many :topics, dependent: :destroy
  has_many :user_keywords, dependent: :destroy
  has_many :keywords, through: :user_keywords

  validates_presence_of :email
  validates :email, uniqueness: true

  enum :industry, {
    not_selected: 0,
    application_development: 1,
    application_security: 2,
    bio_informatics: 3,
    blockchain: 4,
    career_development: 5,
    contributor_opinion: 6,
    devops: 7,
    it_infrastructure: 8,
    machine_learning: 9,
    monitoring_and_observability: 10,
    qa_and_testing: 11,
    tooling: 12,
    web_development: 13,
  }
end
