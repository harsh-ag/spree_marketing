desc "generate all the available smart lists"
namespace :spree do
  namespace :smart_list do
    task generate: :environment do |t, args|
      Spree:EmailList.generate_all
    end
  end
end
