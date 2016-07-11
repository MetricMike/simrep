Rails.application.routes.draw do
  ActiveAdmin.routes(self)

  devise_for :users, controllers: { sessions:           'users/sessions',
                                    omniauth_callbacks: 'users/omniauth_callbacks' }

  devise_scope :user do
    patch '/confirm' => 'confirmations#confirm'
  end

  get '/switch_chapter', to: 'application#switch_chapter', as: :switch_chapter

  resources :characters, except: [:edit, :destroy]
  resources :projects
  resources :bank_accounts, except: [:edit, :destroy], alias: :personal_bank_accounts
  resources :npc_shifts
end
