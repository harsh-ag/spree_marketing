class Spree::EmailCampaign::PromotionalEmail < ActionMailer::Base
  def send_now(contact_emails, email_campaign)
    @email_campaign = email_campaign
    send_email(contact_emails, @email_campaign.template_name)
  end

  private
    def send_email(contact_emails, template_name)
      MandrillMailer::TemplateMailer.mandrill_mail(
        template: template_name,
        to: contact_emails,
        inline_css: true,
      ).deliver
    end
end
