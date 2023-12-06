module Mutations
  module UserKeywords
    class CreateUserKeyword < ::Mutations::BaseMutation
      argument :word, String, required: true

      type Types::UserKeywordType

      def resolve(**attributes)
        keyword_id = Keyword.find_by(word: attributes[:word])&.id
        user_id = context[:current_user]
        user_keyword = UserKeyword.where(user_id: user_id).where(keyword_id: keyword_id).first

        user_keyword ?
        user_keyword : UserKeyword.create!(keyword_id: keyword_id, user_id: user_id)
      end
    end
  end
end
