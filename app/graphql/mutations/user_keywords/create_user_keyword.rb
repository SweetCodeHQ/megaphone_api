module Mutations
  module UserKeywords
    class CreateUserKeyword < ::Mutations::BaseMutation
      argument :user_id,    ID, required: true
      argument :word, String, required: true

      type Types::UserKeywordType

      def resolve(**attributes)
        raise GraphQL::ExecutionError, "Incorrect execution." if context[:current_user] != @prepared_arguments[:user_id].to_i
        keyword_id = Keyword.find_by(word: attributes[:word]).id
        user_id = attributes[:user_id]
        user_keyword = UserKeyword.where(user_id: user_id).where(keyword_id: keyword_id).first

        user_keyword ?
        user_keyword : UserKeyword.create!(keyword_id: keyword_id, user_id: user_id)
      end
    end
  end
end
