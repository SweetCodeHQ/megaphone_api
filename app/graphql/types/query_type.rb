module Types
  class QueryType < Types::BaseObject
    # Add `node(id: ID!) and `nodes(ids: [ID!]!)`
    include GraphQL::Types::Relay::HasNodeField
    include GraphQL::Types::Relay::HasNodesField

    field :user, Types::UserType, null: true do
      description 'Find user by email'
      argument :email, String, required: false
    end

    field :fixate_users, [Types::UserType], null: false do
      description 'Find all Fixate users'
    end

    field :waitlist, [Types::UserType], null: true do
      description 'Show users on waitlist'
    end

    field :users_connection, Types::UserType.connection_type, null: false do
      description 'Find all users with pagination'
    end

    field :user_topics_connection, Types::TopicType.connection_type, null: false do
      description 'find a users topics with pagination'
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

    field :topic, Types::TopicType, null: true do
      description 'Find topic by id'
      argument :id, ID, required: true
    end

    field :random_keywords, [Types::KeywordType], null: true do
      description 'Get random keywords'
    end

    field :top_five_keywords, [Types::KeywordType], null: true do
      description 'Get the top 5 most searched keywords'
    end

    field :banners, [Types::BannerType], null: true do
      description 'Return 4 banners'
    end

    def user(email: nil)
      if context[:current_user]
        User.find(context[:current_user])
      elsif email
        User.where(email: email).limit(1).first
      else
        raise GraphQL::ExecutionError, "Incorrect execution."
      end
    end

    def entity(url:)
      ent = Entity.where(url: url).limit(1).first
      if ent
        raise GraphQL::ExecutionError, "Incorrect execution." unless User.find(context[:current_user]).entities.first&.id == ent.id || context[:admin_request]
        return ent
      else
        return ent
      end
    end

    def market(id:)
      Market.find(id)
    end

    def keyword(id:)
      Keyword.find(id)
    end

    def topic(id:)
      topic = Topic.find(id)
      raise GraphQL::ExecutionError, "Incorrect execution." unless context[:current_user] == topic.user_id

      topic
    end

    def random_keywords
      Keyword.order("RANDOM()").limit(10)
    end

    def top_five_keywords
      Keyword.order(search_count: :desc).limit(5)
    end

    def fixate_users
      raise GraphQL::ExecutionError, "Incorrect execution." unless context[:admin_request]
      User.joins(:entities).where(entities: {name: 'Fixate'})
    end

    def entities
      raise GraphQL::ExecutionError, "Incorrect execution." unless context[:admin_request]
      Entity.all
    end


    def entities_connection
      raise GraphQL::ExecutionError, "Incorrect execution.: #{context[:current_user]}. Admin request: #{context[:admin_request]}" unless context[:admin_request]
      ::Entity.all
    end

    def users_connection
      raise GraphQL::ExecutionError, "Incorrect execution." unless context[:admin_request]
      ::User.all
    end

    def user_topics_connection
      raise GraphQL::ExecutionError, "Incorrect execution." unless context[:current_user]

      ::Topic.where(user_id: context[:current_user]).order(submitted: :desc).order(created_at: :desc)
    end

    def banners
      Banner.all.order(:id)
    end

    def waitlist
      raise GraphQL::ExecutionError, "Incorrect execution." unless context[:admin_request]
      User.where(login_count: 0)
    end
  end
end
