module Types
  class UserType < Types::BaseObject
    field :entities,  [Types::EntityType],  null: true
    field :topics,    [Types::TopicType],   null: true
    field :keywords,  [Types::KeywordType], null: true

    field :created_at, GraphQL::Types::ISO8601DateTime, null: false

    field :id,          ID,      null: false

    field :email,       String,  null: false
    field :is_admin,    Boolean, null: false
    field :is_blocked,  Boolean, null: false
    field :clicked_generate_count, Integer, null: false
    field :login_count,  Integer, null: false

    field :topic_count,  Integer, null: false

    def entities
      Loaders::AssociationLoader.for(object.class, :entities).load(object)
    end

    def topics
      Loaders::AssociationLoader.for(object.class, :topics).load(object)
    end

    def topic_count
      @object.topics.size
    end

    def keywords
      Loaders::AssociationLoader.for(object.class, :keywords).load(object)
    end
  end
end
