module Mutations
  module UserEntities
    class CreateUserEntity < ::Mutations::BaseMutation
      argument :user_id,      ID,     required: true
      argument :entity_id,    ID,     required: true

      type Types::UserEntityType

      def resolve(**attributes)
        UserEntity.create!(attributes)
      end
    end
  end
end
