module Mutations
  module UserKeywords
    class CreateUserKeyword < ::Mutations::BaseMutation
      argument :keyword_id, ID, required: true

      type Types::UserKeywordType

      def resolve(**attributes)
        user_id = context[:current_user]
        user_keyword = UserKeyword.where(user_id: user_id).where(keyword_id: attributes[:keyword_id].to_i).first

        user_keyword ?
        user_keyword : UserKeyword.create!(keyword_id: attributes[:keyword_id].to_i, user_id: user_id)
      end
    end
  end
end
