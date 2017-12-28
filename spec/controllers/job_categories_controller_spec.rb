require 'rails_helper'

RSpec.shared_examples 'unauthorized non-agency-admin people' do
  let(:agency) { FactoryBot.create(:agency) }
  let(:company) { FactoryBot.create(:company) }
  let(:case_manager) { FactoryBot.create(:case_manager, agency: agency) }
  let(:job_developer) { FactoryBot.create(:job_developer, agency: agency) }
  let(:job_seeker) { FactoryBot.create(:job_seeker) }
  let(:company_admin) { FactoryBot.create(:company_admin, company: company) }
  let(:company_contact) { FactoryBot.create(:company_contact, company: company) }

  context 'Not logged in' do
    it_behaves_like 'unauthenticated XHR request'
  end
  context 'Case Manager' do
    it_behaves_like 'unauthorized XHR request' do
      let(:user) { case_manager.user }
    end
  end
  context 'Job Developer' do
    it_behaves_like 'unauthorized XHR request' do
      let(:user) { job_developer.user }
    end
  end
  context 'Job Seeker' do
    it_behaves_like 'unauthorized XHR request' do
      let(:user) { job_seeker.user }
    end
  end
  context 'Company admin' do
    it_behaves_like 'unauthorized XHR request' do
      let(:user) { company_admin.user }
    end
  end
  context 'Company contact' do
    it_behaves_like 'unauthorized XHR request' do
      let(:user) { company_contact.user }
    end
  end
end

RSpec.describe JobCategoriesController, type: :controller do
  describe 'POST #create' do
    let(:jobcat_params) { FactoryBot.attributes_for(:job_category) }
    let(:agency) { FactoryBot.create(:agency) }

    context 'authorized access' do
      before :each do
        aa = FactoryBot.create(:agency_admin, agency: agency)
        sign_in aa.user
      end
      it 'creates new job category for valid parameters' do
        expect { xhr :post, :create, job_category: jobcat_params }
          .to change(JobCategory, :count).by(+1)
      end

      it 'returns success for valid parameters' do
        xhr :post, :create, job_category: jobcat_params
        expect(response).to have_http_status(:success)
      end

      it 'returns errors and error status for invalid parameters' do
        xhr :post, :create, job_category: { name: '', description: '' }
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response).to render_template('shared/_error_messages')
      end
    end
    it_behaves_like 'unauthorized non-agency-admin people' do
      let(:request) { xhr :post, :create, job_category: jobcat_params }
    end
  end

  describe 'GET #show' do
    let(:category) { FactoryBot.create(:job_category) }
    let(:agency) { FactoryBot.create(:agency) }

    context 'authorized access' do
      before :each do
        aa = FactoryBot.create(:agency_admin, agency: agency)
        sign_in aa.user
      end
      context 'job category found' do
        before(:each) do
          xhr :get, :show, id: category
        end

        it 'renders json structure' do
          expect(JSON.parse(response.body))
            .to match('id' => category.id,
                      'name' => category.name,
                      'description' => category.description)
        end
        it 'returns http success' do
          expect(response).to have_http_status(:success)
        end
      end

      context 'job category NOT found' do
        it 'returns http status not_found' do
          xhr :get, :show, id: 0
          expect(response).to have_http_status(:not_found)
        end
      end
    end

    it_behaves_like 'unauthorized non-agency-admin people' do
      let(:request) { xhr :get, :show, id: category }
    end
  end

  describe 'PATCH #update' do
    let(:category) { FactoryBot.create(:job_category) }
    let(:jobcat_params) { FactoryBot.attributes_for(:job_category) }
    let(:agency) { FactoryBot.create(:agency) }

    context 'authorized access' do
      before :each do
        aa = FactoryBot.create(:agency_admin, agency: agency)
        sign_in aa.user
      end

      it 'returns success for valid parameters' do
        xhr :patch, :update, id: category, job_category: jobcat_params
        expect(response).to have_http_status(:success)
      end

      it 'returns errors and error status for invalid parameters' do
        xhr :patch,
            :update,
            id: category,
            job_category: { name: '', description: '' }
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response).to render_template('shared/_error_messages')
      end
    end
    it_behaves_like 'unauthorized non-agency-admin people' do
      let(:request) do
        xhr :patch, :update, id: category, job_category: jobcat_params
      end
    end
  end

  describe 'DELETE #destroy' do
    let!(:category) { FactoryBot.create(:job_category) }
    let(:agency) { FactoryBot.create(:agency) }

    context 'authorized access' do
      before :each do
        aa = FactoryBot.create(:agency_admin, agency: agency)
        sign_in aa.user
      end
      context 'job category found' do
        it 'deletes job category' do
          expect { xhr :delete, :destroy, id: category }
            .to change(JobCategory, :count).by(-1)
        end
        it 'returns http success' do
          xhr :delete, :destroy, id: category
          expect(response).to have_http_status(:success)
        end
      end

      context 'job category NOT found' do
        it 'returns http status not_found' do
          xhr :delete, :destroy, id: 0
          expect(response).to have_http_status(:not_found)
        end
      end
    end
    it_behaves_like 'unauthorized non-agency-admin people' do
      let(:request) { xhr :delete, :destroy, id: category }
    end
  end
end
