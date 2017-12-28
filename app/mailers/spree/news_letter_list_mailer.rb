class Spree::NewsLetterListMailer < ActionMailer::Base
  def send_now(contact)
    @contact = contact
    vars = {
      unsubscribe_link: Spree::Core::Engine.routes.url_helpers.unsubscribe_news_letter_lists_url(email: @contact.email)
    }
    send_email(@contact.email, vars, 'newsletter-signup')
  end

  private
    def send_email(to, vars, template_name)
      MandrillMailer::TemplateMailer.mandrill_mail(
        template: template_name,
        to: to,
        vars: vars,
        inline_css: true,
      ).deliver
    end
end
