Spree::Core::Engine.routes.draw do
  namespace :admin do
    resources :reports, only: [:index] do
      collection do
        get :ten_days_order_count
        get :thirty_days_order_count
      end
    end
  end
end
