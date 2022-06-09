module Types
  class EntityType < Types::BaseObject
    field :markets, [Types::MarketType], null: true

    field :id, ID, null: false

    field :url,    String,  null: false
    field :name,   String,  null: false

    def markets
      Loaders::AssociationLoader.for(object.class, :markets).load(object)
    end
  end
end
