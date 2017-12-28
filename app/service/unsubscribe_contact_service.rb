class UnsubscribeContactService

  attr_accessor :gmail

  def initialize
    crypt = ActiveSupport::MessageEncryptor.new(ENV['shinshu_secret_key'])
    @gmail = Gmail.connect!(Spree::Config[:gmail_unsubscribe_email], crypt.decrypt_and_verify(Spree::Config[:gmail_unsubscribe_password]))
    process_unread_emails
  end

  def process_unread_emails
    emails = get_unread_emails
    emails.each do |email|
      contact_email = email.message.from[0]
      Spree::NewsLetterList.default.unsubscribe(contact_email)
      # email.read!
    end
    gmail.logout
  end

  def get_unread_emails
    @gmail.inbox.emails(:unread)
  end

end
