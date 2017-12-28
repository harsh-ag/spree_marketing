class Spree::Mailchimp::CreateList < ApplicationJob
  def perform(email_list_id)
    email_list = Spree::EmailList.find email_list_id
    MarketingService::MailchimpService::ListService.new.generate_list(email_list)
  end
end
