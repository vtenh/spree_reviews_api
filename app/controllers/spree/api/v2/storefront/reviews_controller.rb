module Spree
  module Api
    module V2
      module Storefront
        class ReviewsController < ::Spree::Api::V2::ResourceController
          before_action :load_product, only: [:create]
          before_action :require_spree_current_user

          def create
            params[:review][:rating].sub!(/\s*[^0-9]*\z/, '') unless params[:review][:rating].blank?
            params[:review][:show_identifier] = params[:review][:show_identifier].to_i == 1

            review = Spree::Review.new(review_params)
            review.product = @product
            review.user = spree_current_user
            review.ip_address = request.remote_ip
            review.locale = I18n.locale.to_s if Spree::Reviews::Config[:track_locale]

            if review.save
              render_serialized_payload { serialize_resource(review) }
            else
              render_error_payload(review.errors.full_messages.join(", "))
            end
          end

          private

          def load_product
            @product = Spree::Product.friendly.find(params[:product_id])
          end

          def resource_serializer
            Spree::V2::Storefront::ReviewDetailSerializer
          end

          def permitted_review_attributes
            [:rating, :title, :review, :name, :show_identifier]
          end
      
          def review_params
            params.require(:review).permit(permitted_review_attributes)
          end
        end
      end
    end
  end
end
