module SpreeReviewsApi
  module Spree
    module ProductDecorator
      def self.prepended(base)
        base.has_many :reviews
      end

      def stars
        avg_rating.try(:round) || 0
      end
  
      def recalculate_rating
        self[:reviews_count] = reviews.reload.approved.count
        self[:avg_rating] = if reviews_count > 0
                              reviews.approved.sum(:rating).to_f / reviews_count
                            else
                              0
                            end
        save
      end  
    end
  end
end

::Spree::Product.prepend(SpreeReviewsApi::Spree::ProductDecorator)
