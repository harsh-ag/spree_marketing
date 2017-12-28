require 'spec_helper'

describe Spree::EmailList do

  describe 'Constants' do
    it 'sets VALID_DATA_SOURCES' do
      expect(Spree::EmailList::VALID_LIST_TYPES).to eq({ news_letter: 'Spree::NewsLetterList' })
    end
  end

  it { is_expected.to validate_presence_of(:name) }
  it { is_expected.to validate_uniqueness_of(:name).scoped_to(:type) }
  it { is_expected.to validate_presence_of(:type) }

  it { is_expected.to have_many(:contacts_email_lists).with_foreign_key(:spree_email_list_id).dependent(:destroy) }
  it { is_expected.to have_many(:contacts).through(:contacts_email_lists) }

  describe 'Instance variables' do
    let(:spree_contact) { create(:contact) }
    let(:newsletter) { create(:newsletter_list) }

    describe '#add_contact' do
      it 'is expected to add contact to list' do
        expect { newsletter.add_contact(spree_contact) }.to change { Spree::ContactsEmailList.count }
      end
    end

    describe '#has_email?' do
      context 'when email is exists in the list' do
        before { newsletter.add_contact(spree_contact) }
        it 'returns true' do
          expect(newsletter.has_email?(spree_contact.email)).to eq true
        end
      end

      context 'when email does not exists in the list' do
        it 'returns false' do
          expect(newsletter.has_email?(spree_contact.email)).to eq false
        end
      end
    end
  end

end
