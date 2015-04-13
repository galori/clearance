Rails.application.routes.draw do
  resources :clearance_batches, only: [:new,:create] do
    resources :items, only: [:index]
  end
  resources :items, :only => :index
  root to: "clearance_batches#index"
end
