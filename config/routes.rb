Rails.application.routes.draw do
  root    'homes#top'
  get     '/top',       to: 'homes#top' # json用
  get     '/homes/calendar', to: 'homes#calendar', as: 'calendar'
  get     '/about',     to: 'homes#about'
  post    '/login',     to: 'sessions#create'
  delete  '/logout',    to: 'sessions#destroy'
  get     '/auth/failure',             to: 'sessions#auth_failure'
  get     '/auth/:provider/callback',  to: 'sessions#create'
  post    '/result',    to: 'searches#result'
  post    '/pixabay',    to: 'searches#pixabay'
  get     'communities/words'
  get     'communities/questions'
  get     'communities/ranking'

  resource :user, only: [:create, :show, :update, :destroy]
  resources :later_lists, only: [:index, :create, :destroy]
  resources :account_activations, only: [:edit]
  resources :learns, controller: :learned_contents do
    resource :favorite, only: [:create, :destroy]
    member do
      get   :question
      get   :question_show
      post  :answer
      post  :again
    end
  end

  namespace :admin do
    get     '/login',     to: 'sessions#new'
    post    '/login',     to: 'sessions#create'
    delete  '/logout',    to: 'sessions#destroy'
    resources :users, only: [:index, :destroy]
    resources :learns, only: [:index, :show, :destroy], controller: :learned_contents
  end
end
