class TopicKeyword < ApplicationRecord
  belongs_to :topic
  belongs_to :keyword
end
