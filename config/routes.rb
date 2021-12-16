Rails.application.routes.draw do
  resources :tags
  get 'quotes/:tag', to: 'tags#quotes'
  get 'frases', to: 'tags#frases'
  get 'buscar_frase_author/:author', to: 'tags#buscar_frase_author'
  devise_for :users
end
