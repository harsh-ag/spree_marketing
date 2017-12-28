module Spree
  class EmailCampaign < ActiveRecord::Base

    BATCH_SIZE = 5000
    DEFAULT_SEND_TIME_GAP = 1.day

    belongs_to :email_list, foreign_key: :spree_email_list_id
    has_many :contacts, through: :email_list
    # validates :template_name, :email_list, presence: true
    has_many :email_messages, foreign_key: :spree_email_campaign_id

    def send_now
      get_contacts.find_in_batches(batch_size: BATCH_SIZE).with_index do |contacts, index|
        Rails.logger { "Sending emails for #{ email_campaign.template_name } for index - #{ index }" }
        Spree::EmailCampaign::SendPromotionalEmailJob.set(wait: (index * 4).minutes).perform_later(id, index)
      end
    end

    def self.sync(since_send_time = nil)
      CampaignSyncJob.perform_later(since_send_time || DEFAULT_SEND_TIME_GAP.ago.to_s)
    end

     def self.generate(campaigns_data)
      campaigns_data.collect do |data|
        list = Spree::EmailList.find_by(external_id: data['recipients']['list_id'])
        create!(external_id: data['id'],
            name: data['settings']['title'],
            email_list: list,
            scheduled_at: data['send_time'])
      end
    end

    private
      def get_contacts
        if email_list.type == 'Spree::NewsLetterList'
          Spree::NewsLetterList.default.contacts.where(spree_contacts_email_lists: { subscribed: true })
        else
          email_list.contacts
        end
      end

  end
end
