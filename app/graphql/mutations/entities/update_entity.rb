module Mutations
  module Entities
    class UpdateEntity < ::Mutations::BaseMutation
      argument :id,       ID,     required: true
      argument :name,     String, required: false
      argument :url,      String, required: false
      argument :credits,  Float, required: false
      argument :request_in_progress, Boolean, required: false

      type Types::EntityType

      def resolve(id:, **attributes)
        raise GraphQL::ExecutionError, "Incorrect execution." if !context[:admin_request] 
        if attributes.keys.include?(:credits)
          attributes[:request_in_progress] = false
          Entity.find(id).tap do |entity|
            entity.update!(attributes)
          end
        else
          Entity.find(id).tap do |entity|
            entity.update!(attributes)
          end
        end
      end
    end
  end
end
