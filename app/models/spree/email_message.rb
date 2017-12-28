module Spree
  class EmailMessage < ActiveRecord::Base

    belongs_to :email_campaign, class_name: 'Spree::EmailCampaign', foreign_key: :spree_email_campaign_id
    belongs_to :email_contact, class_name: 'Spree::Contact', foreign_key: :spree_contact_id
    has_one :email_list, through: :email_campaign
    # Add template id also

    validates :spree_contact_id, :spree_email_campaign_id, presence: true

  end
end
