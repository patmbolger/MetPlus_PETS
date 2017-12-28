module UserDelegates
  extend ActiveSupport::Concern

  included do

    delegate :actable, :acting_as, :actable_type,
             :email, :phone, :unconfirmed_email,
             :first_name, :last_name, :full_name,
             :first_name=, :last_name=, :email=, :pets_user,
             :unconfirmed_email?, :encrypted_password,
             :confirmation_token, :password,
             :password=, :password_confirmation=,
             :approved, :approved=, to: :user

    def is_agency_person?(agency)
      self.is_a?(AgencyPerson) && self.agency == agency
    end

    def is_job_developer?(agency)
      return false unless self.is_agency_person?(agency)
      has_role?(:JD)
    end

    def is_case_manager?(agency)
      return false unless self.is_agency_person?(agency)
      has_role?(:CM)
    end

    def is_agency_admin?(agency)
      return false unless self.is_agency_person?(agency)
      has_role?(:AA)
    end

    def is_job_seeker?
      self.is_a?(JobSeeker)
    end

    def is_company_person?(company)
      self.is_a?(CompanyPerson) && self.company == company
    end

    def is_company_admin?(company)
      return false unless self.is_company_person?(company)
      has_role?(:CA)
    end

    def is_company_contact?(company)
      return false unless self.is_company_person?(company)
      has_role?(:CC)
    end
  end
end
