module Spree
  module V2
    module Storefront
      class ReviewDetailSerializer < BaseSerializer
        set_type :review
        
        attributes :title, :name, :review, :show_identifier, :rating

        has_one :user
        has_one :product
      end
    end
  end
end
