module Mutations
  module Abstracts
    class UpdateAbstract < ::Mutations::BaseMutation
      argument :id,               ID,                          required: true
      argument :text,             String,                      required: false

      type Types::AbstractType

      def resolve(id:, **attributes)
        user_abstract = Abstract.find(@prepared_arguments[:id])
        if @context[:current_user] == user_abstract.topic.user.id
          user_abstract.tap do |abstract|
            abstract.update!(attributes)
          end
        else
          raise GraphQL::ExecutionError, "Incorrect execution."
        end
      end
    end
  end
end
