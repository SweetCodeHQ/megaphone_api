module Types
  class KeywordType < Types::BaseObject
    # field :entities, [Types::EntityType], null: true

    field :id,      ID,      null: false
    field :word,    String,  null: false

    # def entities
    #   Loaders::AssociationLoader.for(object.class, :entities).load(object)
    # end
  end
end
