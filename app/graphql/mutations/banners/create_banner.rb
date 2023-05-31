module Mutations
  module Banners
    class CreateBanner < ::Mutations::BaseMutation
      argument :text,         String, required: true
      argument :purpose,      Integer, required: true
      argument :link,         String, required: false

      type Types::BannerType

      def resolve(**attributes)
        Banner.create!(attributes)
      end
    end
  end
end
