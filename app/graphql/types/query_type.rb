module Types
  class QueryType < Types::BaseObject
    # Add `node(id: ID!) and `nodes(ids: [ID!]!)`
    include GraphQL::Types::Relay::HasNodeField
    include GraphQL::Types::Relay::HasNodesField

    field :user, Types::UserType, null: true do
      description 'Find user by email'
      argument :email, String, required: true
    end

    field :admin_users, [Types::UserType], null: false do
      description 'Find all admin users'
    end

    field :fixate_users, [Types::UserType], null: false do
      description 'Find all Fixate users'
    end

    field :users_connection, Types::UserType.connection_type, null: false do
      description 'Find all users with pagination'
    end

    field :user_topics_connection, Types::TopicType.connection_type, null: true do
      description 'find a users topics with pagination'
      argument :user_id, ID, required: true
    end

    field :entity, Types::EntityType, null: true do
      description 'Find entity by url'
      argument :url, String, required: true
    end

    field :entities, [Types::EntityType], null: true do
      description 'Find all entities'
    end

    field :entities_connection, Types::EntityType.connection_type, null: false do
      description 'Find all entities with pagination'
    end

    field :market, Types::MarketType, null: true do
      description 'Find market by id'
      argument :id, ID, required: true
    end

    field :keyword, Types::KeywordType, null: true do
      description 'Find keyword by id'
      argument :id, ID, required: true
    end

    def user(email:)
      User.where(email: email).limit(1).first
    end

    def entity(url:)
      Entity.where(url: url).limit(1).first
    end

    def market(id:)
      Market.find(id)
    end

    def keyword(id:)
      Keyword.find(id)
    end

    def admin_users
      User.where(is_admin: true)
    end

    def fixate_users
      User.joins(:entities).where(entities: {name: 'Fixate'})
    end

    def entities
      Entity.all
    end

    def entities_connection
      ::Entity.all
    end

    def users_connection
      ::User.all
    end

    def user_topics_connection(user_id:)
      ::Topic.where(user_id: user_id)
    end
  end
end
