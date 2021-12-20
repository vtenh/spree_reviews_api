module SpreeReviewsApi
  module Spree
    module ReviewDecorator
      def has_feedback?(user)
        return false if !user.present?
        feedback_reviews.map(&:user_id).include?(user.id)
      end

      def recalculate_avg_feedback_review_stars
        if feedback_reviews_count <= 0
          self.avg_feedback_stars = 0
        else
          self.avg_feedback_stars = ((feedback_reviews.sum(:rating) / feedback_reviews_count) + 0.5).floor
        end

        save
      end
      
    end
  end
end

::Spree::Review.prepend(SpreeReviewsApi::Spree::ReviewDecorator)
