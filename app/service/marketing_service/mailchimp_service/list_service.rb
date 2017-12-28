module MarketingService
  module MailchimpService
    class ListService < BaseService

      attr_reader :members, :list_uid

      MEMBER_STATUS                   = { unsubscribe: 'unsubscribed', subscribe: 'subscribed' }
      DEFAULT_MEMBER_RETRIEVAL_PARAMS = { params: { 'status': MEMBER_STATUS[:subscribe] } }

      PARAMS = {
        email_type_option: true,
        permission_reminder: 'You are recieving this email because you are subscribed',
        campaign_defaults: {
          from_name: 'default_name',
          from_email: 'default@default.com',
          subject: 'Subscription',
          language: 'english'
        },
        contact: {
          company: 'default',
          address1: 'default',
          city: 'Seattle',
          state: 'WA',
          zip: '98101',
          country: 'USA'
        }
      }

      def initialize(list_uid = nil)
        @list_uid = list_uid
        @members = []
      end

      def generate_list(list)
        p "Generating List #{ list.name }"
        response = gibbon.lists.create(body: { name: list.name }.merge(PARAMS))
        p response
        @list_uid = response['id'] if response['id'].present?
        p "Generated List #{ list.name } -- #{ @list_uid }"
        list.update_column(:external_id, @list_uid)
        response
      end

      def rename_list(list)
        gibbon.lists(list.external_id).update(body: { name: list.name }).merge(PARAMS)
      end

      def update_list(subscribable_emails = [], unsubscribable_uids = [])
        p "Updating List #{ @list_uid }"
        begin
          unsubscribe_members(unsubscribable_uids) if unsubscribable_uids.present?
          subscribe_members(subscribable_emails) if subscribable_emails.any?
        rescue Gibbon::MailChimpError => e
          Rails.logger.error { "Got exception while processing record at Mailchimp #{e}" }
        end
      end

      def subscribe_members(subscribable_emails = [])
        members_batches = subscribable_emails.in_groups_of(BATCH_COUNT, false)
        members_batches.each do |members_batch|
          p "Starting subscribe on mailchimp for members with emails #{ members_batch.join(', ') }"
          members_batch.each do |email|
            params = { body: { email_address: email, status: MEMBER_STATUS[:subscribe] } }
            contact = Spree::Contact.find_by(email: email)
            if member_uid = contact.try(:mailchimp_id)
              response = gibbon.lists(@list_uid).members(member_uid).upsert(params)
            else
              response = gibbon.lists(@list_uid).members.create(params)
            end
            @members << response if response['id']
            p response
            contact.update_column(:mailchimp_id, response['id'])
          end
          p "Finished subscribe on mailchimp for members with emails #{ members_batch.join(', ') }"
        end
        @members
      end

      def unsubscribe_members(unsubscribable_uids = [])
        members_batches = unsubscribable_uids.in_groups_of(BATCH_COUNT, false)
        members_batches.each do |members_batch|
          p "Starting unsubscribe on mailchimp for members with uids #{ members_batch.join('-') }"
          members_batch.each do |uid|
            response = gibbon.lists(@list_uid).members(uid).update(body: { status: MEMBER_STATUS[:unsubscribe] })
            p response
          end
          p "Finished unsubscribe on mailchimp for members with uids #{ members_batch.join(', ') }"
        end
      end
    end
  end
end
