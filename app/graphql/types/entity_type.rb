module Types
  class EntityType < Types::BaseObject
    field :markets,   [Types::MarketType],  null: true
    field :users,     [Types::UserType],    null: true

    field :id,        ID, null: false

    field :url,       String,  null: false
    field :name,      String,  null: true
    field :credits,   Float, null: true

    field :user_count, Int, null: false
    field :topic_count, Int, null: false

    def markets
      Loaders::AssociationLoader.for(object.class, :markets).load(object)
    end

    def users
      Loaders::AssociationLoader.for(object.class, :markets).load(object)
    end

    def user_count
      @object.users.size
    end

    def topic_count
      @object.topics.size
    end
  end
end
