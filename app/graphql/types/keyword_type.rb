module Types
  class KeywordType < Types::BaseObject
    field :markets, [Types::MarketType], null: true

    field :id,      ID,      null: false
    field :word,    String,  null: false

    def entities
      Loaders::AssociationLoader.for(object.class, :markets).load(object)
    end
  end
end
