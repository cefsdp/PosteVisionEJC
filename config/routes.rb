Rails.application.routes.draw do
  devise_for :users
  root to: 'pages#home'
  get '/loader_etude', to: 'pages#loader_etude'
  get '/saver_etude', to: 'pages#saver_etude'
  get '/loader_adherent', to: 'pages#loader_adherent'
  get '/saver_adherent', to: 'pages#saver_adherent'
  get '/test', to: 'pages#testing_page'
  post 'documents/generer', to: 'documents#generer' 

  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  resources :adherents
  resources :etudes do
    resources :phases
    resources :intervenants
  end

  resources :documents

end
