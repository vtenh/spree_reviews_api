Spree::Core::Engine.add_routes do
  # Add your extension routes here

  namespace :api, defaults: { format: 'json' } do
    namespace :v2 do
      namespace :storefront do
        resources :products, only: [] do
          resources :reviews, only: [:create, :index, :new]
        end
      end
    end
  end
end
