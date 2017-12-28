module Spree
  class ContactsEmailList < ActiveRecord::Base
    belongs_to :contact, foreign_key: :spree_contact_id
    belongs_to :email_list, foreign_key: :spree_email_list_id

    before_create :check_subscribe_for_user
    before_update :toggle_subscribe_for_user
    before_destroy :uncheck_subscribe_for_user

    private

      def check_subscribe_for_user
        user = contact.try(:user)
        return true unless user.present?
        user.update(subscribed: true)
      end

      def uncheck_subscribe_for_user
        user = contact.try(:user)
        return true unless user.present?
        user.update(subscribed: false)
      end

      def toggle_subscribe_for_user
        user = contact.try(:user)
        return true unless user.present?
        user.update(subscribed: subscribed)
      end

  end
end
