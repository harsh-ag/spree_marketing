require 'spec_helper'

describe Spree::EmailCampaign do

  describe 'Constants' do
    it 'sets BATCH_SIZE' do
      expect(Spree::EmailCampaign::BATCH_SIZE).to eq(10000)
    end
  end

  it { is_expected.to validate_presence_of(:template_name) }
  it { is_expected.to validate_presence_of(:email_list) }

  it { is_expected.to belong_to(:email_list) }

  describe 'Instance methods' do
    let(:spree_contact) { create(:contact) }
    let(:email_campaign) { create(:email_campaign) }
    before do
      email_campaign.email_list.create_or_subscribe(spree_contact.email)
    end
    describe '#send_now' do
      it 'is expected to call contacts on email_campaign' do
        expect(email_campaign).to receive_message_chain(:email_list, :contacts).and_return(email_campaign.email_list.contacts)
        email_campaign.send_now
      end

      it 'enques the promotional email job' do
        ActiveJob::Base.queue_adapter = :test
        email_campaign.send(:send_now)
        expect(Spree::EmailCampaign::SendPromotionalEmailJob).to have_been_enqueued
      end
    end
  end
end
