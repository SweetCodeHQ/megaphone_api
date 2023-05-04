module Types
  class TopicType < Types::BaseObject
    field :keywords, [Types::KeywordType], null: true
    field :abstract, Types::AbstractType, null: true

    field :id,        ID,         null: false
    field :text,      String,     null: false
    field :submitted, Boolean,    null: false

    def abstract
      Loaders::AssociationLoader.for(object.class, :abstract).load(object)
    end

    def keywords
      Loaders::AssociationLoader.for(object.class, :keywords).load(object)
    end
  end
end
