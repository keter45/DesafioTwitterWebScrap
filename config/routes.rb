Rails.application.routes.draw do  
  get 'user/busca', to: 'user#search', as: :search_user
  resources :user, only:[:new, :create, :destroy,:edit,:update]
  root to: "user#index"
end
