module Mutations
  module Entities
    class CreateEntity < ::Mutations::BaseMutation
      argument :url,     String,      required: true
      argument :name,    String,      required: false

      type Types::EntityType

      def resolve(**attributes)
        raise GraphQL::ExecutionError, "Incorrect execution." unless context[:current_user]
        Entity.create!(attributes)
      end
    end
  end
end
