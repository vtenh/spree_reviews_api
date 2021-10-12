module Spree
  module Api
    module V2
      module Storefront
        module Account
          class ReviewableLineItemsController < ::Spree::Api::V2::ResourceController
            before_action :require_spree_current_user
            before_action :load_order

            def collection
              reviewable_line_items = ReviewableLineItemList.new(user: spree_current_user, order: @order)
              reviewable_line_items.call
            end

            def collection_serializer
              Spree::V2::Storefront::LineItemSerializer
            end

            private
            def load_order
              @order = spree_current_user.orders.complete.find_by!(number: params[:order_id])
            end
          end
        end
      end
    end
  end
end
