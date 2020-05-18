Rails.application.routes.draw do
  root    'homes#top'
  get     'communities/words'
  get     'communities/questions'
  get     'communities/ranking'
  get     '/top',       to: 'homes#top' # カレンダーjson用
  get     '/homes/calendar', as: 'calendar'
  get     'homes/always_dictionary'
  get     '/about',     to: 'homes#about'
  get     '/help',      to: 'homes#help'
  post    '/login',     to: 'sessions#create'
  delete  '/logout',    to: 'sessions#destroy'
  get     '/auth/failure',             to: 'sessions#auth_failure'
  get     '/auth/:provider/callback',  to: 'sessions#auth_success'
  post    'sessions/sns_remember'
  get     'sessions/test_login'
  post    '/result',     to: 'searches#result'
  post    '/pixabay',    to: 'searches#pixabay'

  resources :account_activations, only: [:edit]
  resources :contacts,            only: [:index, :create, :destroy]
  resources :consulted_words,     only: [:index, :destroy]
  resources :later_lists,         only: [:index, :create, :destroy]
  resources :learn_templates,     only: [:create, :update, :show]
  resources :password_resets,     only: [:new, :create, :edit, :update]
  resources :related_images,      only: [:destroy]
  resources :learns, controller: :learned_contents do
    resource :favorite, only: [:create, :destroy]
    member do
      get   :question, :question_show
      post  :again, :answer, :import
    end
  end
  resource :user, only: [:create, :show, :update, :destroy] do
    member do
      get :user_skill
      post :set_user_skill
    end
  end
  resources :cycles, only: [:new, :destroy] do
    collection do
      patch :set
      post  :default
    end
  end

  namespace :admin do
    get     '/login',     to: 'sessions#new'
    post    '/login',     to: 'sessions#create'
    delete  '/logout',    to: 'sessions#destroy'
    resources :learns, only: [:index, :show, :destroy], controller: :learned_contents
    resources :users, only: [:index, :destroy, :show] do
      resources :contacts, only: [:create, :destroy]
    end
  end
end
