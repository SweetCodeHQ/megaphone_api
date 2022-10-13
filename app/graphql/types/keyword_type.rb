module Types
  class KeywordType < Types::BaseObject
    field :markets, [Types::MarketType], null: true

    field :id,          ID,       null: false
    field :word,        String,   null: false
    field :search_count, Int,    null: false

    field :user_count,  Int,     null: false

    def entities
      Loaders::AssociationLoader.for(object.class, :markets).load(object)
    end

    def user_count
      @object.users.size
    end
  end
end
