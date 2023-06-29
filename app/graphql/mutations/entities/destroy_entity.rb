module Mutations
  module Entities
    class DestroyEntity < ::Mutations::BaseMutation
      argument :id, ID, required: true

      type Types::EntityType

      def resolve(id:)
        Entity.find(id).destroy
      end
    end
  end
end
