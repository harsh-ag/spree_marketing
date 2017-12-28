require 'spec_helper'
describe Spree::Admin::EmailConfigurationsController, type: :controller do

  stub_authorization!

  describe 'GET #show' do
    before { spree_get :show }

    it { is_expected.to respond_with(200) }
    it { is_expected.to render_template(:show) }
  end

  describe 'GET #update' do
    before { spree_put :update, { mailchimp_api_key: 'Test_key', gmail_unsubscribe_email: 'Test_email',
      email_admin_list: 'Test_list', gmail_unsubscribe_password: 'Test_password' } }
    it { is_expected.to respond_with(302) }
    it { is_expected.to redirect_to(action: :show) }

    it 'is expected to set mailchimp_api_key in cofing' do
      expect(Spree::Config[:mailchimp_api_key]).to eq 'Test_key'
    end
    it 'is expected to set gmail_unsubscribe_email in cofing' do
      expect(Spree::Config[:gmail_unsubscribe_email]).to eq 'Test_email'
    end
    it 'is expected to set email_admin_list in cofing' do
      expect(Spree::Config[:email_admin_list]).to eq 'Test_list'
    end
    it 'is expected to set gmail_unsubscribe_password in cofing' do
      expect(Spree::Config[:gmail_unsubscribe_password]).not_to eq ''
    end
  end

end
