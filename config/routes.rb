Rails.application.routes.draw do
  ActiveAdmin.routes(self) rescue ActiveAdmin::DatabaseHitDuringLoad

  devise_for :users, controllers: { sessions:           'users/sessions',
                                    omniauth_callbacks: 'users/omniauth_callbacks' }

  devise_scope :user do
    patch '/confirm' => 'confirmations#confirm'
  end

  get '/switch_chapter', to: 'application#switch_chapter', as: :switch_chapter

  resources :characters, except: [:edit, :destroy] do
    get 'all', on: :collection
  end
  resources :projects
  resources :bank_accounts, except: [:edit, :destroy] do
    get 'all', on: :collection
  end
  resources :npc_shifts

  authenticate :user, -> (user) { user.admin? } do
    require 'sidekiq/web'
    mount Sidekiq::Web => '/sidekiq'
    mount PgHero::Engine, at: '/pghero'
  end

  if Rails.env.development?
    mount LetterOpenerWeb::Engine, at: "/letter_opener"
  end
end
