class ReviewableLineItemList
  def initialize(user:, order:)
    @user = user
    @order = order
  end

  def call
    line_items = order_line_items.joins("INNER JOIN spree_variants ON spree_variants.id = spree_line_items.variant_id")
                                 .joins("INNER JOIN (#{unreviewed_product_query}) as unreviewed_products ON unreviewed_products.id = spree_variants.product_id")


    line_items
  end

  private
  def order_line_items
    @order.line_items
  end

  def unreviewed_product_query
    products_query = Spree::Product.select("spree_products.id, spree_reviews.id as review_id")
                             .joins("LEFT JOIN spree_reviews ON spree_reviews.product_id = spree_products.id")
                             .where("spree_reviews.id IS NULL")

    products_query.to_sql
  end
end
