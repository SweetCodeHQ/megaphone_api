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
        entity = Entity.find(id)
        raise GraphQL::ExecutionError, "Incorrect execution." unless context[:admin_request] || User.find(context[:current_user]).entities[0].id == id.to_i
        if attributes.keys.include?(:credits)
          current_credits = entity.credits || 0
          raise GraphQL::ExecutionError, "Incorrect execution." unless current_credits > attributes[:credits] || context[:admin_request] 
          attributes[:request_in_progress] = false if context[:admin_request]
          entity.tap do |entity|
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
