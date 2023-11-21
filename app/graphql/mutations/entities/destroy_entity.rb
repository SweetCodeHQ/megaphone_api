module Mutations
  module Entities
    class DestroyEntity < ::Mutations::BaseMutation
      argument :id, ID, required: true

      type Types::EntityType

      def resolve(id:)
        raise GraphQL::ExecutionError, "Incorrect execution." if !context[:admin_request]
        Entity.find(id).destroy
      end
    end
  end
end
