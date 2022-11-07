module Types
  class TopicType < Types::BaseObject

    field :id,      ID,         null: false
    field :text,    String,     null: false
    field :submitted, Boolean,  null: false
  end
end
