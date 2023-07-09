Rails.application.routes.draw do
  namespace :api do
    resources :articles, param: :slug, only: [:index, :show, :create, :update, :destroy]
  end
end
