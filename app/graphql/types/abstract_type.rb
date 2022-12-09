module Types
  class AbstractType < Types::BaseObject

    field :id,      ID,         null: false
    field :text,    String,     null: false
    field :topic_id, ID,        null: false
  end
end
