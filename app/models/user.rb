class User < ApplicationRecord

  validates_presence_of :email
  validates :email, uniqueness: true
end
