RSpec.shared_examples 'unauthorized request' do
  before :each do
    warden.set_user user
    request
  end

  it 'redirects to the home page' do
    expect(response).to redirect_to(root_path)
  end

  it 'sets the flash' do
    expect(flash[:alert]).to match(/^You are not authorized to/)
  end
end

RSpec.shared_examples 'unauthenticated request' do
  before do
    request
  end

  it 'redirects to the home page' do
    expect(response).to redirect_to(root_path)
  end

  it 'sets the flash' do
    expect(flash[:alert]).to match(/You need to login to/)
  end
end