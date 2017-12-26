module UserDelegates
  extend ActiveSupport::Concern

  included do
    delegate :actable, :acting_as,
             :email, :first_name, :last_name, :full_name, :unconfirmed_email,
             :first_name=, :last_name=, :email=, :pets_user,
             :unconfirmed_email?, :encrypted_password, to: :user

    def is_agency_person?(agency)
      self.is_a?(AgencyPerson) && self.agency == agency
    end

    def is_job_seeker?
      self.is_a?(JobSeeker)
    end

    def is_company_person? company
      self.is_a?(CompanyPerson) && self.company == company
    end
  end
end
