FactoryGirl.define do
  factory :email_campaign, class: Spree::EmailCampaign do
    template_name :test
    email_list { create(:newsletter_list) }
  end
end
