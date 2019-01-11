# frozen_string_literal: true

class ApplicationController < ActionController::Base
  before_action :configure_permitted_parameters, if: :devise_controller?

  # Redirects to the root page after sign in
  def after_sign_in_path_for(resource)
    root_path
  end

  protected

    def configure_permitted_parameters
      devise_parameter_sanitizer.permit(:sign_up, keys: [:avatar, :name, :description])
      devise_parameter_sanitizer.permit(:account_update, keys: [:avatar, :name, :description])
    end
end
