module Mutations
  module Entities
    class UpdateEntity < ::Mutations::BaseMutation
      argument :id,       ID,     required: true
      argument :name,     String, required: false
      argument :url,      String, required: false
      argument :credits,  Float, required: false

      type Types::EntityType

      def resolve(id:, **attributes)
        Entity.find(id).tap do |entity|
          entity.update!(attributes)
        end
      end
    end
  end
end
