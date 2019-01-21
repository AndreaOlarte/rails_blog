# frozen_string_literal: true

Rails.application.routes.draw do
  root 'articles#index'
  devise_for :users
  resources :articles do
    resources :comments, shallow: true, except: %i[index show]
  end
  resources :dashboard, only: %i[index]
  namespace :admin do
    resources :tags, only: %i[create update destroy]
  end
end
