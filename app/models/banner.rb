class Banner < ApplicationRecord
  enum :purpose, {
    display_banner: 0,
    privacy_statement: 1,
    cookie_policy: 2,
    eula: 3
  }

  validates_presence_of :purpose, :text
  validates_uniqueness_of :purpose
end
