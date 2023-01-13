module Mutations
  module Abstracts
    class DestroyAbstract < ::Mutations::BaseMutation
      argument :id, ID, required: true

      type Types::AbstractType

      def resolve(id:)
        Abstract.find(id).destroy
      end
    end
  end
end
