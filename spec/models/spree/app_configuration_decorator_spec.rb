require 'spec_helper'

describe Spree::AppConfiguration do
  it 'expects spree config to have mailchimp_api_key' do
    expect(Spree::Config).to have_preference(:mailchimp_api_key)
  end
  it 'expects spree config to have gmail_unsubscribe_email' do
    expect(Spree::Config).to have_preference(:gmail_unsubscribe_email)
  end
  it 'expects spree config to have gmail_unsubscribe_password' do
    expect(Spree::Config).to have_preference(:gmail_unsubscribe_password)
  end
  it 'expects spree config to have email_admin_list' do
    expect(Spree::Config).to have_preference(:email_admin_list)
  end
end
