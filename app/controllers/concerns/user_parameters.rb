module UserParameters
  extend ActiveSupport::Concern

  def handle_user_form_parameters parameters
    return parameters if parameters.dig(:user_attributes, :password)&.present?

    parameters[:user_attributes].delete(:password)
    parameters[:user_attributes].delete(:password_confirmation)
    parameters
  end
end
