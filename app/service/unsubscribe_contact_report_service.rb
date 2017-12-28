class UnsubscribeContactReportService

  def initialize
    generate_unsubscribed_emails_report
  end

  private

    def generate_unsubscribed_emails_report
      newsletter = Spree::NewsLetterList.default
      unsubscribed_emails = newsletter.contacts.where('optout_date > ?', 1.day.ago).pluck(:email)
      return if unsubscribed_emails.empty?
      Spree::NewsLetterListReportMailer.send_now(unsubscribed_emails).deliver_now
    end

end
