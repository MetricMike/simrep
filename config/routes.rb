Rails.application.routes.draw do
  ActiveAdmin.routes(self) # rescue ActiveAdmin::DatabaseHitDuringLoad

  devise_for :users, controllers: { sessions:           'users/sessions',
                                    omniauth_callbacks: 'users/omniauth_callbacks' }

  devise_scope :user do
    patch '/confirm' => 'confirmations#confirm'
  end

  resources :characters, except: [:edit, :update, :destroy] do
    get 'print', on: :member
  end
  resources :projects
  resources :bank_accounts, except: [:edit, :destroy] do
    get 'print', on: :member
  end
  resources :npc_shifts

  if ENV['MTOWER'].present?
    # authenticate :user, -> (user) { user.admin? } do
    require 'sidekiq/web'
    mount Sidekiq::Web, at: '/sidekiq'
    mount PgHero::Engine, at: '/pghero'
  end

  namespace :api do
    namespace :v1, defaults: { format: :json } do
      jsonapi_resources :chapters
    end
  end
end
