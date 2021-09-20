module Spree
  module Api
    module V2
      module Storefront
        module Account
          class ReviewsController < ::Spree::Api::V2::ResourceController
            before_action :require_spree_current_user

            def collection
              reviews = Spree::Review.includes(review_includes)
                                     .where(user_id: spree_current_user.id)

              if params[:approved].present?
                reviews = params[:approved].to_i == 1 ? reviews.approved : reviews.not_approved
              end
              reviews = params[:oldest] == '1' ? reviews.oldest_first : reviews.most_recent_first

              reviews
            end

            private

            def collection_serializer
              Spree::V2::Storefront::UserReviewListSerializer
            end

            def review_includes
              [product: [variants: [:images], master: [:images, :default_price]]]
            end
          end
        end
      end
    end
  end
end
