module Types
  class MarketType < Types::BaseObject
    field :entities, [Types::EntityType], null: true
    field :keywords, [Types::KeywordType], null: true

    field :id,      ID,      null: false
    field :name,    String,  null: false

    def entities
      Loaders::AssociationLoader.for(object.class, :entities).load(object)
    end
  end
end
