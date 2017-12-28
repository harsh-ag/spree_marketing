module Spree
  class NewsLetterList < Spree::EmailList

    NAME_TEXT = 'NewsLetter'

    def create_or_subscribe(email)
      contact = Spree::Contact.find_or_initialize_by(email: email)
      if contact.new_record?
        contact.data_source = Spree::Contact::VALID_DATA_SOURCES[:website]
      end
      contact.optin_date = Time.current
      contact.optout_date = nil
      if contact.save
        add_contact(contact)
        MarketingService::MailchimpService::ListService.new(mailchimp_id).update_list([email]) if contact.persisted?
        send_newsletter_email(contact)
      end
    end

    def unsubscribe(email)
      contact = contacts.find_by(email: email)
      return unless contact
      contact.contacts_email_lists.find_by(spree_email_list_id: id).update(subscribed: false)
      MarketingService::MailchimpService::ListService.new(mailchimp_id).update_list([], [contact.mailchimp_id])
      contact.update(optout_date: Time.current)
    end

    def self.default
      Spree::NewsLetterList.find_by(name: 'NewsLetter')
    end

    private
      def send_newsletter_email(contact)
        return if contact.data_source == 'CSV'
        contact.reload
        Spree::NewsLetterListMailer.send_now(contact).delay
      end

  end
end
