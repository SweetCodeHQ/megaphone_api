module Types
  class UserType < Types::BaseObject
    field :entities, [Types::EntityType], null: true

    field :id, ID, null: false

    field :email,    String,  null: false
    field :is_admin, Boolean, null: false

    def entities
      Loaders::AssociationLoader.for(object.class, :entities).load(object)
    end
  end
end
