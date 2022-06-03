module Types
  class EntityType < Types::BaseObject

    field :id, ID, null: false

    field :url,    String,  null: false
    field :name,   String,  null: false
  end
end
