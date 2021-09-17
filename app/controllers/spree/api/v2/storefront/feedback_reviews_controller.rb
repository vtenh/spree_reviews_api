module Spree
  module Api
    module V2
      module Storefront
        class FeedbackReviewsController < ::Spree::Api::V2::ResourceController
          before_action :require_spree_current_user, only: [:create]
          before_action :load_review
          before_action :sanitize_rating

          def create
            feedback_review = @review.feedback_reviews.new(feedback_review_params)
            feedback_review.user = spree_current_user
            feedback_review.locale = I18n.locale.to_s if Spree::Reviews::Config[:track_locale]

            if feedback_review.save
              render_serialized_payload { serialize_resource(feedback_review) }
            else
              render_error_payload(feedback_review.errors.full_messages.join(", "))
            end
            
          end

          private

          def resource_serializer
            Spree::V2::Storefront::FeedbackReviewDetailSerializer
          end

          def load_review
            @review = Spree::Review.where(user_id: spree_current_user.id).find(params[:review_id])
          end

          def permitted_feedback_review_attributes
            [:rating, :comment]
          end
      
          def feedback_review_params
            params.require(:feedback_review).permit(permitted_feedback_review_attributes)
          end

          def sanitize_rating
            params[:feedback_review][:rating].to_s.sub!(/\s*[^0-9]*\z/, '') if params[:feedback_review].present? && params[:feedback_review][:rating].present?
          end
        end
      end
    end
  end
end
