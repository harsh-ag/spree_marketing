require 'spec_helper'

describe Spree::OutOfStockList do

  describe 'Instance methods' do
    let(:out_of_stock_list) { create(:out_of_stock_list) }
    let!(:newsletter_list) { create(:newsletter_list) }

    describe '#create_or_subscribe' do
      before do
        out_of_stock_list.create_or_subscribe('a@a.com')
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

    describe '#find_or_create' do
      let(:variant) { create(:variant) }
      it 'is expected to return the list' do
        expect(Spree::OutOfStockList.find_or_create(variant)).not_to be_blank
      end
    end
  end

end
