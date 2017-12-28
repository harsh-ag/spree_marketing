require 'spec_helper'

describe Spree::Contact do

  describe 'Constants' do
    it 'sets VALID_DATA_SOURCES' do
      expect(Spree::Contact::VALID_DATA_SOURCES).to eq({ csv: 'CSV', website: 'WebSite' })
    end
  end

  it { is_expected.to validate_presence_of(:email) }
  it { is_expected.to allow_value('sawan@vinsol.com', 'a@a.com').for(:email) }
  it { is_expected.not_to allow_value('sawanvinsol.com').for(:email) }
  it { is_expected.to validate_numericality_of(:placed_orders_count).only_integer.is_greater_than_or_equal_to(0) }
  it { is_expected.to validate_inclusion_of(:data_source).in_array(Spree::Contact::VALID_DATA_SOURCES.values) }

  it { is_expected.to have_many(:contacts_email_lists) }
  it { is_expected.to have_many(:email_lists).through(:contacts_email_lists) }
  it { is_expected.to have_many(:news_letter_lists).through(:contacts_email_lists) }
  it { is_expected.to have_many(:subscribed_lists).through(:news_letter_lists) }

  describe 'Instance methods' do
    let(:spree_contact) { create(:contact) }

    describe '#subscribe' do
      let(:newsletter) { create(:newsletter_list) }
      it 'is expected to get first newsletter' do
        expect(Spree::NewsLetterList).to receive(:first).and_return(newsletter)
        spree_contact.subscribe
      end
    end

    describe '#subscribed?' do
      context 'when newsletter_list is not present' do
        it 'returns nil' do
          expect(spree_contact.subscribed?).to eq nil
        end
      end

      context 'when newsletter_list is present' do
        let(:newsletter) { create(:newsletter_list) }
        context 'when contact is subscribed to newsletter' do
          before { newsletter.create_or_subscribe(spree_contact.email) }
          it 'returns true' do
            expect(spree_contact.subscribed?).to eq true
          end
        end

        context 'when contact is not subscribed to newsletter' do
          it 'returns nil' do
            expect(spree_contact.subscribed?).to eq nil
          end
        end
      end
    end
  end
end
