require 'spec_helper'
describe Spree::Admin::EmailCampaignsController, type: :controller do

  stub_authorization!

  describe 'GET #send_now' do
    before do
      spree_put :send_now, { id: 1 }
      allow_any_instance_of(Spree::EmailCampaign).to receive(:send_now)
    end
    it { is_expected.to respond_with(302) }
    it { is_expected.to redirect_to(action: :index) }
    it { is_expected.to set_flash }
  end

end
