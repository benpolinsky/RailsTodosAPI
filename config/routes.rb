Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  resources :todos do
    get 'done', to: 'todos#done'
    resources :items
  end
  post 'auth/login', to: 'authentication#authenticate'
  post 'signup', to: 'users#create'
end
