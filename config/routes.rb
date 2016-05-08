Rails.application.routes.draw do
  ActiveAdmin.routes(self)
  devise_for :users, controllers: {confirmations: 'confirmations', registrations: 'registrations', sessions: 'users/sessions'}

  devise_scope :user do
    patch "/confirm" => "confirmations#confirm"
  end

  resources :characters, except: [:edit, :destroy]
  resources :projects
  resources :bank_accounts, except: [:edit, :destroy]
  resources :npc_shifts
end
