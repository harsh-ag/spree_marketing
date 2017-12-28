require 'spec_helper'

describe Spree::ExportService::Contact do

  let(:contact) { create(:contact) }
  let(:service) { Spree::ExportService::Contact.new([contact]) }

  describe 'constant' do
    it 'sets HEADERS' do
      expect(Spree::ExportService::Contact::HEADERS).to eq [:email_address, :status_subscribed_unsubscribed, :optin_date, :optout_date, :number_of_orders, :avg_order_value, :date_of_last_order, :location_country]
    end
  end

  describe 'instance methods' do
    describe 'initialize' do
      it 'sets contacts' do
        expect(service.instance_variable_get(:@contacts)).to eq [contact]
      end
    end

    describe 'to_csv_data' do
      it 'generates a CSV file' do
        expect(CSV).to receive(:generate)
        service.to_csv_data
      end
    end

    describe '#email_address' do
      it 'returns email_address' do
        expect(service.send(:email_address, contact)).to eq contact.email
      end
    end

    describe '#status_subscribed_unsubscribed' do
      it 'returns subscribed' do
        expect(service.send(:status_subscribed_unsubscribed, contact)).to eq 'No'
      end
    end

    describe '#optin_date' do
      it 'returns optin_date' do
        expect(service.send(:optin_date, contact)).to eq contact.optin_date
      end
    end

    describe '#optout_date' do
      it 'returns optout_date' do
        expect(service.send(:optout_date, contact)).to eq contact.optout_date
      end
    end

    describe '#number_of_orders' do
      it 'returns number_of_orders' do
        expect(service.send(:number_of_orders, contact)).to eq contact.placed_orders_count
      end
    end

    describe '#avg_order_value' do
      it 'returns avg_order_value' do
        expect(service.send(:avg_order_value, contact)).to eq contact.avg_order_value
      end
    end

    describe '#date_of_last_order' do
      it 'returns date_of_last_order' do
        expect(service.send(:date_of_last_order, contact)).to eq contact.last_placed_order_at
      end
    end

    describe '#location_country' do
      it 'returns location_country' do
        expect(service.send(:location_country, contact)).to eq contact.location
      end
    end

  end

end
