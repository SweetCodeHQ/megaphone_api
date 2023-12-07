module Mutations
  module UserEntities
    class CreateUserEntity < ::Mutations::BaseMutation
      argument :entity_id,    ID,     required: true

      type Types::UserEntityType

      def resolve(**attributes)
        attrs = attributes
        attrs[:user_id] = context[:current_user]
        UserEntity.create!(attrs)
      end
    end
  end
end
