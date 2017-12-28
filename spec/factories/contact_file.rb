FactoryGirl.define do
  factory :contact_file, class: Spree::ContactFile do
    attachment Rack::Test::UploadedFile.new(File.join(Rails.root, '..', '..', 'spec', 'factories', 'import.csv'))
    viewable_type 'Spree::Contact'
  end

  factory :invalid_contact_file, class: Spree::ContactFile do
    attachment Rack::Test::UploadedFile.new(File.join(Rails.root, '..', '..', 'spec', 'factories', 'import_invalid.csv'))
    viewable_type 'Spree::Contact'
  end
end
