class Spree::NewsLetterListReportMailer < ActionMailer::Base

  def send_now(unsubscribed_emails)
    @unsubscribed_emails = unsubscribed_emails
    mail to: Spree::Config[:email_admin_list], subject: 'List of Unsubscribed contacts', from: Spree::Config[:email_admin_list]
  end

end
