class ReviewableProductList
  def initialize(user:)
    @user = user
  end

  def call
    product_ids = user_ordered_products.map(&:id)
    product_ids -= user_reviewed_product_ids

    Spree::Product.includes(:translation).find(product_ids)
  end

  private
  def user_ordered_products(user)
 
    
    products = Spree::Product.select("DISTINCT(spree_products.id)")
                  .joins("INNER JOIN spree_variants ON spree_variants.product_id = spree_products.id")
                  .joins("INNER JOIN spree_line_items ON spree_line_items.variant_id = spree_variants.id")
                  .joins("INNER JOIN (#{user_order_query}) as user_completed_orders ON user_completed_orders.id = spree_line_items.order_id")
         
                  products.to_sql
  end

  def user_reviewed_product_ids
    Spree::Review.where(user_id: @user.id).map(&:product_id).uniq
  end

  def testa(user)
    line_items  = Spree::LineItem.joins("INNER JOIN (#{user_order_query(user)}) as user_orders ON user_orders.id = spree_line_items.order_id")
                                 .joins("INNER JOIN spree_variants ON spree_variants.id = spree_line_items.id")
                                 .joins("INNER JOIN spree_products ON spree_products.id = spree_variants.product_id")
                                 .joins("LEFT JOIN spree_reviews on spree_reviews.product_id = spree_products.id")
                                 line_items.to_sql
  end

  def user_order_query(user)
    user.orders.complete.to_sql
  end

  def unreviewed_product(user)
    products = Spree::Product.select("spree_products.id, spree_reviews.id as review_id")
                             .joins("LEFT JOIN spree_reviews ON spree_reviews.product_id = spree_products.id")
                             .where("spree_reviews.id IS NULL")

                             products.to_sql
  end
  
  
end
