module Mutations
  module Banners
    class UpdateBanner < ::Mutations::BaseMutation
      argument :id,      ID,      required: true
      argument :text,    String,  required: false
      argument :link,    String,  required: false

      type Types::BannerType

      def resolve(id:, **attributes)
        if context[:admin_request]
          Banner.find(id).tap do |banner|
            banner.update!(attributes)
          end
        else
          raise GraphQL::ExecutionError, "Incorrect execution."
        end
      end
    end
  end
end
