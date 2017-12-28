require 'spec_helper'

describe Spree::ImportService::ContactFile do
  let!(:newsletter) { create(:newsletter_list) }
  let(:contact_file) { create(:contact_file) }

  describe 'import contacts from CSV' do
    context 'when import file is valid' do
      before { contact_file }
      it 'creates contacts' do
        expect(Spree::Contact.count).to eq 2
      end
    end

    context 'when import file is invalid' do
      let(:invalid_contact_file) { create(:invalid_contact_file) }
      before { invalid_contact_file }
      it 'does not creates contacts' do
        expect(Spree::Contact.count).to eq 0
      end
    end
  end
end
