namespace :spree do
  namespace :newsletter do
    desc 'Unsubscribe contacts report'
    task :unsubscribe_report => :environment do
      UnsubscribeContactReportService.new
    end
  end
end
