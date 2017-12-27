module UserParameters
  extend ActiveSupport::Concern

  def handle_user_form_parameters parameters
    return parameters unless parameters.dig(:user_attributes, :password)&.blank?

    parameters[:user_attributes].delete(:password)
    parameters[:user_attributes].delete(:password_confirmation)
    parameters
  end
end
