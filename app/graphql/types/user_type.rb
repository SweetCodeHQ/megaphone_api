module Types
  class UserType < Types::BaseObject

    field :id, ID, null: false

    field :email, String, null: false
    field :is_admin, Boolean, null: false
  end
end
