class Spree::EmailCampaign::SendPromotionalEmailJob < ApplicationJob

  queue_as :promo_email

  def perform(email_campaign_id, index)
    email_campaign = Spree::EmailCampaign.find email_campaign_id
    contact_ids = email_campaign.send(:get_contacts).
      limit(Spree::EmailCampaign::BATCH_SIZE).
      offset(Spree::EmailCampaign::BATCH_SIZE * index).pluck(:id)

    contact_ids.in_groups_of(500).each do |contact_id_batches|
      contact_emails = Spree::Contact.where(id: contact_id_batches).pluck(:email)
      Spree::EmailCampaign::PromotionalEmail.send_now(contact_emails, email_campaign).deliver_later
    end
  end

end
