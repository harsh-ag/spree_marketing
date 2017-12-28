module Spree
  class Contact < ActiveRecord::Base

    VALID_DATA_SOURCES = {
      csv: 'CSV',
      website: 'WebSite'
    }

    validates :email, presence: true
    validates :email, email: true, uniqueness: true, allow_blank: true
    validates :placed_orders_count, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
    validates :data_source, inclusion: { in: VALID_DATA_SOURCES.values }

    has_many :contacts_email_lists, foreign_key: :spree_contact_id
    has_many :email_lists, through: :contacts_email_lists
    has_many :news_letter_lists, -> { where(spree_email_lists: { type: 'Spree::NewsLetterList' }) }, through: :contacts_email_lists, source: :email_list
    has_many :subscribed_lists, -> { where(spree_contacts_email_lists: { subscribed: true }) }, through: :news_letter_lists, source: :contacts_email_lists
    has_many :email_messages, foreign_key: :spree_contact_id

    def subscribe
      newsletter = Spree::NewsLetterList.default
      newsletter.add_contact(self)
    end

    def subscribed?
      return unless news_letter_lists.present?
      contacts_email_lists.find_by(spree_email_list_id: Spree::NewsLetterList.default.id).try(:subscribed)
    end

    def user
      Spree::User.find_by(email: email)
    end

    def self.subscribed
      Spree::NewsLetterList.default.contacts.where(spree_contacts_email_lists: { subscribed: true }).where(id: ids)
    end

  end
end
