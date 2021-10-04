module Spree
  module V2
    module Storefront
      class ReviewUserProfileSerializer < BaseSerializer
        set_type :review_user_profile

        attributes :first_name, :last_name, :gender

        has_one :profile_pic
      end
    end
  end
end
