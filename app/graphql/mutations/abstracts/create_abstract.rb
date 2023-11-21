module Mutations
  module Abstracts
    class CreateAbstract < ::Mutations::BaseMutation
      argument :topic_id,     ID,     required: true
      argument :text,         String, required: true

      type Types::AbstractType

      def resolve(**attributes)
        if authorized_user? 
          Abstract.create!(attributes) 
        else 
          raise GraphQL::ExecutionError, "Incorrect execution."
        end
      end

      def authorized_user?
        @context[:current_user] == Topic.find(@prepared_arguments[:topic_id]).user.id
      end
    end
  end
end
