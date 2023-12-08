module Mutations
  module Users
    class CreateUser < ::Mutations::BaseMutation
      argument :email,     String,      required: true

      type Types::UserType

      def resolve(**attributes)
        domain = attributes[:email].split("@")[1]

        entity = Entity.find_by(url: domain) || Entity.create!(url: domain)
        user = User.find_by(email: attributes[:email]) || User.create!(attributes)
        user_entity = UserEntity.where(user_id: user.id).where(entity_id: entity.id).first || UserEntity.create!({user_id: user.id, entity_id: entity.id})

        user
      end
    end
  end
end