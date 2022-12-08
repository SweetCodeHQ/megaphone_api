class Abstract < ApplicationRecord
  belongs_to :topic 
  validates_presence_of :text
end
