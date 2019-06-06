require 'sidekiq/web'

Rails.application.routes.draw do

  mount Sidekiq::Web => '/sidekiq'
  mount API => '/'
  mount GrapeSwaggerRails::Engine => '/docs' if defined? GrapeSwaggerRails
  mount ActionCable.server => '/cable'

  root 'posts#index'
  resources :devices, only: [:create]
  resources :users
  resources :posts do
    resources :comments, only: [:create, :destroy]
    resources :likes, only: [:create, :destroy]
  end

  get '.well-known/assetlinks' => "wellknown#assetlinks"
  get '500', to: 'errors#not_found'
  post "likes/:post_id/create" => "likes#create"
  post "likes/:post_id/destroy" => "likes#destroy"
  patch "posts/tagsreflesh1" => "posts#tagsreflesh1"
  patch "posts/tagsreflesh2" => "posts#tagsreflesh2"
  patch "comments/create" => "comments#create"
  get "posts/auto_complete" => "posts#auto_complete"

  get "/auth/twitter/callback" => "auth#create"
  delete "/auth/destroy/twitter" => 'auth#destroy', as: :destroy_connection
  post "/auth/create/account" => "sessions#create"
  get "/auth/create/account" => "sessions#create"
  get "/auth/failure" => "sessions#failure"
  get '/auth/:provider/callback', to: 'sessions#create'
  delete "/signout", to: "sessions#destroy"

  get 'tag' , as: 'tag', to: 'posts#tag'
  get 'unclear' , as: 'unclear', to: 'posts#unclear'
  get 'rss' , as: 'rss', to: 'posts#rss'
  get 'map' , as: 'map', to: 'posts#map'
  get 'gallery' , as: 'gallery', to: 'posts#gallery'
  get 'form2' , as: 'form2', to: 'posts#form2'
  get 'form3' , as: 'form3', to: 'posts#form3'

  get 'notifications/link_through'
  get 'notifications/update_all' => "notifications#update_all"
  get 'notifications/:id/link_through', to: 'notifications#link_through',
  as: :link_through

end