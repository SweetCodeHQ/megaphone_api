module Types
  class UserType < Types::BaseObject
    field :entities,  [Types::EntityType],  null: true
    field :topics,    [Types::TopicType],   null: true
    field :keywords,  [Types::KeywordType], null: true

    field :created_at, GraphQL::Types::ISO8601DateTime, null: false
    field :accepted_eula_on, GraphQL::Types::ISO8601DateTime, null: true
    field :accepted_privacy_on, GraphQL::Types::ISO8601DateTime, null: true
    field :saw_banner_on, GraphQL::Types::ISO8601DateTime, null: true
    field :accepted_cookies_on, GraphQL::Types::ISO8601DateTime, null: true

    field :id,          ID,      null: false

    field :email,       String,  null: false
    field :is_admin,    Boolean, null: false
    field :is_blocked,  Boolean, null: false
    field :onboarded,   Boolean, null: false
    field :clicked_generate_count, Integer, null: false
    field :login_count,  Integer, null: false
    field :topic_count,  Integer, null: false
    field :industry,     Integer, null: false


    def entities
      Loaders::AssociationLoader.for(object.class, :entities).load(object)
    end

    def topics
       @object.topics.sort {|topic| topic.created_at} 
    end

    def topic_count
      @object.topics.size
    end

    def keywords
      Loaders::AssociationLoader.for(object.class, :keywords).load(object)
    end

    def industry
      User.industries[@object.industry]
    end
  end
end
