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

    field :entity, Types::EntityType, null: true do
      description 'Find entity by url'
      argument :url, String, required: true
    end

    field :entities, [Types::EntityType], null: true do
      description 'Find all entities'
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

    def entities
      Entity.all
    end
  end
end
