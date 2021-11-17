module Spree
  module V2
    module Storefront
      class FeedbackReviewDetailSerializer < BaseSerializer
        set_type :feedback_review

        attributes :rating, :comment, :created_at, :updated_at

        has_one :user
        has_one :review, serializer: Spree::V2::Storefront::ReviewSerializer
      end
    end
  end
end
