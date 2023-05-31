module Types
  class BannerType < Types::BaseObject
    field :id,        ID,         null: false
    field :text,      String,     null: false
    field :link,      String,    null: true
    field :purpose,      Integer,    null: false

    def purpose
      Banner.purposes[@object.purpose]
    end
  end
end
