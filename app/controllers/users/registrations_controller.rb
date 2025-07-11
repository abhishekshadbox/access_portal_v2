# app/controllers/users/registrations_controller.rb
module Users
  class RegistrationsController < Devise::RegistrationsController
    before_action :configure_sign_up_params, only: [:create]

    protected

    def configure_sign_up_params
      devise_parameter_sanitizer.permit(:sign_up, keys: [:name, :date_of_birth, :parent_email, :parental_consent])
    end
  end
end
