module Mutations
  module Banners
    class CreateBanner < ::Mutations::BaseMutation
      argument :text,         String, required: true
      argument :purpose,      Integer, required: true
      argument :link,         String, required: false

      argument :accepted_eula_on, GraphQL::Types::ISO8601DateTime, required: false
      argument :accepted_privacy_on, GraphQL::Types::ISO8601DateTime, required: false
      argument :saw_banner_on, GraphQL::Types::ISO8601DateTime, required: false
      argument :accepted_cookies_on, GraphQL::Types::ISO8601DateTime, required: false

      type Types::BannerType

      def resolve(**attributes)
        Banner.create!(attributes)
      end
    end
  end
end
