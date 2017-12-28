require 'spec_helper'

describe Spree::ContactsEmailList do

  it { is_expected.to belong_to(:contact).with_foreign_key(:spree_contact_id) }
  it { is_expected.to belong_to(:email_list).with_foreign_key(:spree_email_list_id) }
  it { is_expected.to callback(:check_subscribe_for_user).before(:create) }
  it { is_expected.to callback(:toggle_subscribe_for_user).before(:update) }
  it { is_expected.to callback(:uncheck_subscribe_for_user).before(:destroy) }


  describe 'Instance methods' do
    let(:spree_contact) { create(:contact) }
    let(:newsletter) { create(:newsletter_list) }
    before do
      newsletter.create_or_subscribe(spree_contact.email)
      @contact_email_list = spree_contact.contacts_email_lists.last
    end

    describe '#check_subscribe_for_user' do
      context 'when no corresponding user found for email id' do
        it 'returns true' do
          expect(@contact_email_list.send(:check_subscribe_for_user)).to eq true
        end
      end

      context 'when there is a user for same email id' do
        let!(:user) { create(:user, email: spree_contact.email) }
        it 'marks user as subscribed' do
          expect { @contact_email_list.send(:check_subscribe_for_user) }.to change { user.reload.subscribed }.from(false).to(true)
        end
      end
    end

    describe '#uncheck_subscribe_for_user' do
      context 'when no corresponding user found for email id' do
        it 'returns true' do
          expect(@contact_email_list.send(:uncheck_subscribe_for_user)).to eq true
        end
      end

      context 'when there is a user for same email id' do
        let!(:user) { create(:user, email: spree_contact.email, subscribed: true) }
        it 'marks user as unsubscribed' do
          expect { @contact_email_list.send(:uncheck_subscribe_for_user) }.to change { user.reload.subscribed }.from(true).to(false)
        end
      end
    end

    describe '#toggle_subscribe_for_user' do
      context 'when no corresponding user found for email id' do
        it 'returns true' do
          expect(@contact_email_list.send(:toggle_subscribe_for_user)).to eq true
        end
      end

      context 'when there is a user for same email id' do
        context 'when self is marked as subscribed' do
          let!(:user) { create(:user, email: spree_contact.email) }
          before { @contact_email_list.update_column(:subscribed, true) }
          it 'marks user as subscribed' do
            expect { @contact_email_list.send(:toggle_subscribe_for_user) }.to change { user.reload.subscribed }.from(false).to(true)
          end
        end

        context 'when self is marked as unsubscribed' do
          let!(:user) { create(:user, email: spree_contact.email, subscribed: true) }
          before { @contact_email_list.update_column(:subscribed, false) }
          it 'marks user as unsubscribed' do
            expect { @contact_email_list.send(:toggle_subscribe_for_user) }.to change { user.reload.subscribed }.from(true).to(false)
          end
        end
      end
    end
  end
end
