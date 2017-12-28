class Spree::EmailCampaign::CampaignSyncJob < ActiveJob::Base
  queue_as :default

  def perform(since_send_time = nil)
    campaign_service = MarketingService::MailchimpService::CampaignService.new
    campaigns_data = campaign_service.retrieve_sent_campaigns(since_send_time)
    Spree::EmailCampaign.generate(campaigns_data) if campaigns_data.any?
  end

end
