module Spree
  module V2
    module Storefront
      class UserReviewListSerializer < BaseSerializer
        set_type :review

        attributes :title, :name, :review, :show_identifier, :rating

        has_one :product
      end
    end
  end
end
