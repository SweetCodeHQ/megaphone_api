module Mutations
  module Entities
    class CreateEntity < ::Mutations::BaseMutation
      argument :url,     String,      required: true
      argument :name,    String,      required: true

      type Types::EntityType

      def resolve(**attributes)
        Entity.create!(attributes)
      end
    end
  end
end
