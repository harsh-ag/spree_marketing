require 'spec_helper'
describe Spree::Admin::ContactsController, type: :controller do

  stub_authorization!

  describe 'GET #index' do
    before { spree_get :index }
    it { is_expected.to respond_with(200) }
    it { is_expected.to render_template(:index) }
  end

  describe 'POST #import' do
    before { spree_post :import }
    it { is_expected.to respond_with(302) }
    it { is_expected.to redirect_to(action: :index) }
    it { is_expected.to set_flash }
  end

end
