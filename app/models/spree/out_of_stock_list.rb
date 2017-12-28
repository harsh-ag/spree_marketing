module Spree
  class OutOfStockList < Spree::EmailList

    before_validation :set_name

    def self.find_or_create(variant)
      list = self.find_by(variant_sku: variant.sku)
      return list if list.present?
      list = self.create(variant_sku: variant.sku)
    end

    def create_or_subscribe(email)
      contact = Spree::Contact.find_or_initialize_by(email: email)
      if contact.new_record?
        contact.data_source = Spree::Contact::VALID_DATA_SOURCES[:website]
      end
      return unless contact.save
      MarketingService::MailchimpService::ListService.new(mailchimp_id).update_list([email]) if contact.persisted?
      add_contact(contact)
      subscribe_to_newsletter(contact)
    end

    private

      def subscribe_to_newsletter(contact)
        newsletter = Spree::NewsLetterList.default
        return if newsletter.contacts.where(email: contact.email).exists?
        newsletter.create_or_subscribe(contact.email)
      end

      def set_name
        variant = Spree::Variant.find_by(sku: variant_sku)
        size = variant.option_values.joins(:option_type).where(spree_option_types: { name: 'Size' }).first.try(:name)
        self.name = "OutOfStockList::#{variant.sku}::#{size}"
        self.name = Rails.env + "::#{self.name}" unless Rails.env.production?
      end

  end
end
