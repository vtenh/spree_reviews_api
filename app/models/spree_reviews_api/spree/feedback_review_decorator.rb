module SpreeReviewsApi
  module Spree
    module FeedbackReviewDecorator
      def self.prepended(base)
        base.validate :validate_own_review_feedback

        base.after_save :recalculate_review_feedback

        base.belongs_to :review, dependent: :destroy, counter_cache: true
      end

      def validate_own_review_feedback
        if user_id == review.user_id
          errors.add(:user_id, 'Unable to give feedback on your own review!')
        end
      end

      def recalculate_review_feedback
        review.recalculate_avg_feedback_review_stars if review.present?
      end
    end
  end
end

Spree::FeedbackReview.prepend(SpreeReviewsApi::Spree::FeedbackReviewDecorator) if Spree::FeedbackReview.included_modules.exclude?(SpreeReviewsApi::Spree::FeedbackReviewDecorator)
