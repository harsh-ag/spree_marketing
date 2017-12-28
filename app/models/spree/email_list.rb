module Spree
  class EmailList < ActiveRecord::Base
    VALID_LIST_TYPES = {
      news_letter: 'Spree::NewsLetterList'
    }

    SMART_LISTS = ['Spree::NewsLetterList']

    validates :name, :type, presence: true
    validates :name, uniqueness: { scope: :type }

    has_many :contacts_email_lists, foreign_key: :spree_email_list_id, dependent: :destroy
    has_many :contacts, through: :contacts_email_lists
    has_many :email_campaigns
    has_many :email_messages, through: :email_campaigns
    after_create :generate_list_on_marketing_service
    after_update :rename_list_on_marketing_service, if: :name_changed?

    def add_contact(contact)
      contacts_email_list = contacts_email_lists.find_or_create_by(spree_contact_id: contact.id)
      contacts_email_list.update(subscribed: true)
    end

    def has_email?(email)
      contacts.where(email: email).exists?
    end

    def refresh
      contacts_email_lists.delete_all
      ActiveRecord::Base.connection.execute(generate_sql_statement('test_for_now'))
    end

    def generate_sql_statement(list_name)
      contact_ids = Spree::Contact.ransack(JSON.parse(search_options)).result.pluck(:id)
      sql = "INSERT INTO spree_contacts_email_lists (spree_email_list_id, spree_contact_id) VALUES"
      values = contact_ids.map { |contact_id| " (#{id}, #{contact_id})" }.join(',')
      sql + values
    end

    def self.create_with_options(options)
      name = generate_random_name
      email_list = create(name: name, type: VALID_LIST_TYPES[:news_letter], search_options: options.to_json)
      email_list.refresh
      email_list
    end

    def self.generate_random_name
      loop do
        name = "TEMPLATE_#{ SecureRandom.hex(3) }"
        return name unless exists?(name: name)
      end
    end

    def self.generator
      list = find_by(name: NAME_TEXT)
      list ? list.update_list : create(name: NAME_TEXT)
    end

    def self.generate_all
      SMART_LISTS.each do |list_type|
        list_type.constantize.generator
      end
    end

    private

      def generate_list_on_marketing_service
        MarketingService::MailchimpService::ListService.new.generate_list(self)
      end

      def rename_list_on_marketing_service
        MarketingService::MailchimpService::ListService.new.rename_list(self)
      end

  end
end
