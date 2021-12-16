Rails.application.routes.draw do
  namespace :api, defaults: {formta: :json} do
    resources :tags
    get 'buscar_frase_tag/tag=:tag', to: 'tags#buscar_frase_tag'
    get 'frases', to: 'tags#frases'
    get 'buscar_frase_author/author=:author', to: 'tags#buscar_frase_author'
  end
  devise_for :users
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
