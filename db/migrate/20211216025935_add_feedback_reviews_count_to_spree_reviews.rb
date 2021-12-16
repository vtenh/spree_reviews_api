class AddFeedbackReviewsCountToSpreeReviews < ActiveRecord::Migration[6.1]
  def change
    add_column :spree_reviews, :feedback_reviews_count, :integer
    add_column :spree_reviews, :avg_feedback_stars, :float, default: '0.0'
  end
end
