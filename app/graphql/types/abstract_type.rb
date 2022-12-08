module Types
  class AbstractType < Types::BaseObject

    field :id,      ID,         null: false
    field :text,    String,     null: false
  end
end
