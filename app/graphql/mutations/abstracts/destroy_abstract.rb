module Mutations
  module Abstracts
    class DestroyAbstract < ::Mutations::BaseMutation
      argument :id, ID, required: true

      type Types::AbstractType

      def resolve(id:)
        user_abstract = Abstract.find(@prepared_arguments[:id])

        if @context[:current_user] == user_abstract.topic.user.id
          user_abstract.destroy
        else
          raise GraphQL::ExecutionError, "Incorrect execution."
        end
      end
    end
  end
end
