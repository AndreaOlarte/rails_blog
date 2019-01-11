# frozen_string_literal: true

Rails.application.routes.draw do
  devise_for :users
  resources :articles do
    resources :comments, shallow: true, except: %i[index show]
  end
  get 'dashboard/index'
end
