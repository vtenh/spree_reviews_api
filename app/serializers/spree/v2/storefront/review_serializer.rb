module Spree
  module V2
    module Storefront
      class ReviewSerializer < BaseSerializer
        set_type :review
        
        attributes :title, :name, :review, :show_identifier, :rating, :created_at, :updated_at
      end
    end
  end
end
