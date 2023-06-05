module Mutations
  module Banners
    class UpdateBanner < ::Mutations::BaseMutation
      argument :id,      ID,      required: true
      argument :text,    String,  required: false
      argument :link,    String,  required: false

      argument :accepted_eula_on, GraphQL::Types::ISO8601DateTime, required: false
      argument :accepted_privacy_on, GraphQL::Types::ISO8601DateTime, required: false
      argument :saw_banner_on, GraphQL::Types::ISO8601DateTime, required: false
      argument :accepted_cookies_on, GraphQL::Types::ISO8601DateTime, required: false

      type Types::BannerType

      def resolve(id:, **attributes)
        Banner.find(id).tap do |banner|
          banner.update!(attributes)
        end
      end
    end
  end
end
