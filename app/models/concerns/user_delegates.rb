module UserDelegates
  extend ActiveSupport::Concern

  included do
    delegate :actable, :acting_as,
             :email, :first_name, :last_name, :full_name, :unconfirmed_email,
             :first_name=, :last_name=, :pets_user, to: :user
  end
end
