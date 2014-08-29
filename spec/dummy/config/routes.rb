Rails.application.routes.draw do

  mount Blokade::Engine => "/blokade"
  match :unauthorized, to: 'dashboard#unauthorized', via: [:get]

  resources :leads

  root to: 'dashboard#index'
end
