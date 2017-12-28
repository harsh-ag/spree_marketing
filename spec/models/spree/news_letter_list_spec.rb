require 'spec_helper'

describe Spree::NewsLetterList do

  describe 'Instance variables' do
    let(:newsletter) { create(:newsletter_list) }

    describe '#create_or_subscribe' do
      before do
        newsletter.create_or_subscribe('a@a.com')
        @contact = Spree::Contact.last
      end
      it 'creates customer' do
        expect(Spree::Contact.count).to eq 1
      end

      it 'adds customer in the list' do
        expect(@contact.persisted?).to eq true
      end

      it 'sets data_source as website' do
        expect(@contact.data_source).to eq 'WebSite'
      end

      it 'setts optin date' do
        expect(@contact.optin_date).not_to be_blank
      end
    end

    describe 'unsubscribe' do
      let(:spree_contact) { create(:contact) }
      before { newsletter.create_or_subscribe(spree_contact.email) }
      it 'unsubscribes the user from newsletter list' do
        expect { newsletter.unsubscribe(spree_contact.email) }.to change { spree_contact.contacts_email_lists.find_by(spree_email_list_id: newsletter.id).subscribed }
      end
    end
  end

end
