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
    web_application_development: 1,
    application_security: 2,
    monitoring_and_observability: 3,
    information_technology: 4,
    machine_learning: 5,
    data_science: 6,
    devops: 7,
    quality_and_testing: 8
  }
end
