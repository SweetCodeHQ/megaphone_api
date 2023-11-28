module Mutations
  module Entities
    class DestroyEntity < ::Mutations::BaseMutation
      argument :id, ID, required: true

      type Types::EntityType

      def resolve(id:)
        raise GraphQL::ExecutionError, "Incorrect execution." unless context[:admin_request] && User.find(context[:current_user]).is_admin
        Entity.find(id).destroy
      end
    end
  end
end
