module Mutations
  module UserKeywords
    class CreateUserKeyword < ::Mutations::BaseMutation
      argument :user_id,    ID, required: true
      argument :word, String, required: true

      type Types::UserKeywordType

      def resolve(**attributes)
        keyword_id = Keyword.find_by(word: attributes[:word]).id
        user_id = attributes[:user_id]
        UserKeyword.create!(keyword_id: keyword_id, user_id: user_id)
      end
    end
  end
end
