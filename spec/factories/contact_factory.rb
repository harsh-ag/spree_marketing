FactoryGirl.define do
  factory :contact, class: Spree::Contact do
    email FFaker::Internet.email
    data_source 'CSV'
  end
end
