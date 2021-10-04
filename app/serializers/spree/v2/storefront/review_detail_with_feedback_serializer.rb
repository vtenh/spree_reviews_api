module Spree
  module V2
    module Storefront
      class ReviewDetailWithFeedbackSerializer < BaseSerializer
        set_type :review
        
        attributes :title, :name, :review, :show_identifier, :rating

        attribute :feedback_stars do |review|
          review.feedback_stars
        end

        attribute :has_current_user_feedback do |review, params|
          review.has_feedback?(params[:user])
        end

        attribute :is_own_review do |review, params|
          params[:user].present? && params[:user].id == user.id
        end

        has_one :user, serializer: :review_user_profile
        has_one :product
      end
    end
  end
end
