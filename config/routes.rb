Rails.application.routes.draw do
  ActiveAdmin.routes(self)

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
end
