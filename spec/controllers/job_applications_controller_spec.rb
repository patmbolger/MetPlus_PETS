require 'rails_helper'
include ServiceStubHelpers::Cruncher

RSpec.describe JobApplicationsController, type: :controller do

  let(:job) { FactoryGirl.create(:job) }
  let(:job_seeker) { FactoryGirl.create(:job_seeker) }
  let(:invalid_application) { FactoryGirl.create(:job_application,
                    job: job, job_seeker: job_seeker, status: 'accepted')}
  let(:valid_application) { FactoryGirl.create(:job_application,
                    job: job, job_seeker: job_seeker) }

  before(:each) do
    stub_cruncher_authenticate
    stub_cruncher_job_create
  end

  describe 'PATCH accept' do
    context 'Invalid Job Application' do
      before (:each) do
        patch :accept, id: invalid_application
      end
      it 'look for the invalid application' do
        expect(assigns(:job_application)).to eq invalid_application
      end
      it 'show a flash[:alert]' do
        expect(flash[:alert]).to eq "Invalid action on inactive job application."
      end
      it 'redirect to the specific job application index page' do
        expect(response).to redirect_to(applications_job_url(invalid_application.job))
      end
    end

    context 'Valid Job Application' do
      before (:each) do
        expect_any_instance_of(JobApplication).to receive(:accept)
        patch :accept, id: valid_application
      end
      it 'show a flash[:info]' do
        expect(flash[:info]).to eq "Job application accepted."
      end
      it 'redirect to the specific job application index page' do
        expect(response).to redirect_to(applications_job_url(valid_application.job))
      end
    end
  end

  describe 'PATH reject' do
    before (:each) do
      expect_any_instance_of(JobApplication).to receive(:reject)
      patch :reject, id: valid_application
    end
    it 'show a flash[:info]' do
      expect(flash[:notice]).to eq "Job application rejected."
    end
    it 'redirect to the specific job application index page' do
      expect(response).to redirect_to(applications_job_url(valid_application.job))
    end
  end

  describe 'GET show' do
    context 'Invalid Request' do
      it 'shows a flash[:alert]' do
        get :show, id: anything
        expect(flash[:alert]).to eq "Job Application Entry not found."
      end
    end
  end

  describe 'GET download_resume' do
    context 'Successful download' do
      it 'does not raise exception' do
        get :download_resume, id: valid_application
        expect(response).to_not set_flash
      end
    end
    context 'Error: Resume not found in DB' do
      it 'sets flash message' do
        get :download_resume, id: valid_application
        expect(flash[:alert]).to eq 'Error: Resume not found in DB'
      end
    end
    context 'Error: Resume not found in Cruncher' do
      it 'sets flash message' do
        stub_cruncher_file_download_notfound
        get :download_resume, id: valid_application
        expect(flash[:alert]).to eq 'Error: Resume not found in Cruncher'
      end
    end
  end
end
