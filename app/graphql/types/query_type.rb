module Types
  class QueryType < Types::BaseObject
    # Add `node(id: ID!) and `nodes(ids: [ID!]!)`
    include GraphQL::Types::Relay::HasNodeField
    include GraphQL::Types::Relay::HasNodesField

    field :user, Types::UserType, null: true do
      description 'Find user by email'
      argument :email, String, required: true
    end

    def user(email:)
      User.where(email: email).limit(1).first
    end
  end
end
