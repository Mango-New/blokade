Blokade::Engine.routes.draw do
  resources :permissions, except: [:destroy]
  root to: 'permissions#index'
end
