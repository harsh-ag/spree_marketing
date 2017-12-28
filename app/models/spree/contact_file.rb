module Spree
  class ContactFile < Asset
    validate :no_attachment_errors

    has_attached_file :attachment,
                      url: '/spree/csv/:id/:style/:basename.:extension',
                      path: ':rails_root/public/spree/csv/:id/:style/:basename.:extension'
    validates_attachment :attachment,
      presence: true,
      content_type: { content_type: %w(text/csv text/plain) }

    after_commit :process_contacts, on: :create

    private
      def no_attachment_errors
        unless attachment.errors.empty?
          errors.add :attachment, "Paperclip returned errors for file '#{attachment_file_name}' - check ImageMagick installation or image source file."
          false
        end
      end

      def process_contacts
        Spree::ContactFile::CreateJob.perform_later(id)
      end
  end
end
