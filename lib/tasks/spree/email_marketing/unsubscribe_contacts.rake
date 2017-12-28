namespace :spree do
  namespace :newsletter do
    desc 'Unsubscribe contacts'
    task :unsubscribe => :environment do
      UnsubscribeContactService.new
    end
  end
end
