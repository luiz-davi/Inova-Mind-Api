Rails.application.routes.draw do
  namespace :api, defaults: {formta: :json} do
    resources :tags
    get 'buscarFrase', to: 'tags#buscarFrase'
  end
  devise_for :users
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
