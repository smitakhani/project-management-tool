# frozen_string_literal: true

class ApplicationController < ActionController::Base
    # Prevent CSRF attacks by raising an exception.
    # For APIs, you may want to use :null_session instead.
    protect_from_forgery with: :exception
    include Pundit::Authorization
    include Pagy::Backend
    rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized
 
    before_action :configure_permitted_parameters, if: :devise_controller?

    protected

        def configure_permitted_parameters
            # devise_parameter_sanitizer.for(:sign_up) { |u| u.permit(:name, :email, :password) }
            devise_parameter_sanitizer.permit(:sign_up, keys: [:username, :email, :password])
            devise_parameter_sanitizer.permit(:account_update, keys: [:username, :email, :password, :current_password])

            # devise_parameter_sanitizer.for(:account_update) { |u| u.permit(:name, :email, :password, :current_password) }
        end
    private

    def user_not_authorized
        flash[:alert] = "You are not authorized to perform this action."
        redirect_to(request.referrer || root_path)
    end
end
