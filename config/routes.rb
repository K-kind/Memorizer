Rails.application.routes.draw do
  root    'homes#top'
  get     '/top',       to: 'homes#top' # カレンダーjson用
  get     '/homes/calendar', to: 'homes#calendar', as: 'calendar'
  get     '/about',     to: 'homes#about'
  post    '/login',     to: 'sessions#create'
  delete  '/logout',    to: 'sessions#destroy'
  get     '/auth/failure',             to: 'sessions#auth_failure'
  get     '/auth/:provider/callback',  to: 'sessions#auth_success'
  post    'sessions/sns_remember'
  post    '/result',     to: 'searches#result'
  post    '/pixabay',    to: 'searches#pixabay'
  get     'communities/words'
  get     'communities/questions'
  get     'communities/ranking'

  resources :later_lists, only: [:index, :create, :destroy]
  resources :account_activations, only: [:edit]
  resource :user, only: [:create, :show, :update, :destroy] do
    member do
      get :user_skill
      post :set_user_skill
    end
  end
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
