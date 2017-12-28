module Spree
  AppConfiguration.class_eval do
    preference :mailchimp_api_key, :string, default: 'default'
    preference :gmail_unsubscribe_email, :string, default: 'default'
    preference :gmail_unsubscribe_password, :string, default: 'default'
    preference :email_admin_list, :string, default: 'default@default.com'
  end
end
