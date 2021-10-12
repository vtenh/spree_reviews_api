Spree::Core::Engine.add_routes do
  # Add your extension routes here

  namespace :api, defaults: { format: 'json' } do
    namespace :v2 do
      namespace :storefront do
        namespace :account do
          resources :reviews, only: [:index]
          resources :orders, only: [] do
            resources :reviewable_line_items, only: [:index]
          end
        end

        resources :products, only: [] do
          resources :reviews, only: [:create, :index]
        end

        resources :reviews, only: [] do
          resources :feedback_reviews, only: [:create]
        end
      end
    end
  end
end
