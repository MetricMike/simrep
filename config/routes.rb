Rails.application.routes.draw do
  ActiveAdmin.routes(self)
  devise_for :users, controllers: {confirmations: 'confirmations', registrations: 'registrations'}

  devise_scope :user do
    patch "/confirm" => "confirmations#confirm"
  end

  resources :characters, except: [:edit, :update, :destroy]
  resources :projects
  resources :bank_accounts, except: [:edit, :update, :destroy]
  resources :npc_shifts
end
