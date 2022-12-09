module Mutations
  module Abstracts
    class CreateAbstract < ::Mutations::BaseMutation
      argument :topic_id,     String, required: true
      argument :text,         String, required: true

      type Types::AbstractType

      def resolve(**attributes)
        Abstract.create!(attributes)
      end
    end
  end
end
