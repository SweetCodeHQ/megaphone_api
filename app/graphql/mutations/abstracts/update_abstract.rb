module Mutations
  module Abstracts
    class UpdateAbstract < ::Mutations::BaseMutation
      argument :id,               ID,                          required: true
      argument :text,             String,                      required: false

      type Types::AbstractType

      def resolve(id:, **attributes)
        Abstract.find(id).tap do |abstract|
          abstract.update!(attributes)
        end
      end
    end
  end
end
