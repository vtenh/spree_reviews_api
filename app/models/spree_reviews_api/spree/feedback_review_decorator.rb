module SpreeReviewsApi
  module Spree
    module FeedbackReviewDecorator
      def self.prepended(base)
        base.after_save :recalculate_review_feedback

        base.belongs_to :review, dependent: :destroy, counter_cache: true
      end

      def recalculate_review_feedback
        review.recalculate_avg_feedback_review_stars if review.present?
      end
    end
  end
end

::Spree::FeedbackReview.prepend(SpreeReviewsApi::Spree::FeedbackReviewDecorator)
