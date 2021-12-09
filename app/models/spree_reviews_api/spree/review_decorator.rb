module SpreeReviewsApi
  module Spree
    module ReviewDecorator
      def has_feedback?(user)
        return false if !user.present?
        feedback_reviews.map(&:user_id).include?(user.id)
      end

      def total_feedback_reviews
        feedback_reviews.size
      end
    end
  end
end

::Spree::Review.prepend(SpreeReviewsApi::Spree::ReviewDecorator)
