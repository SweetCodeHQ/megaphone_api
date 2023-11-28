module Types
  class TopicType < Types::BaseObject
    field :keywords, [Types::KeywordType], null: true
    field :abstract, Types::AbstractType, null: true

    field :id,            ID,         null: false
    field :text,          String,     null: false
    field :submitted,     Boolean,    null: false
    field :content_type,  Integer,    null: false
    field :created_at, GraphQL::Types::ISO8601DateTime, null: false

    def abstract
      Loaders::AssociationLoader.for(object.class, :abstract).load(object)
    end

    def keywords
      Loaders::AssociationLoader.for(object.class, :keywords).load(object)
    end

    def content_type
      Topic.content_types[@object.content_type]
    end

    def self.authorized?(object, context)
      super && (object.user.id == context[:current_user] || context[:admin_request])
    end
  end
end
