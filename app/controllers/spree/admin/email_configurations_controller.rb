module Spree
  module Admin
    class EmailConfigurationsController < Spree::Admin::BaseController

      def show
      end

      def update
        Spree::Config[:mailchimp_api_key] = params[:mailchimp_api_key]
        Spree::Config[:gmail_unsubscribe_email] = params[:gmail_unsubscribe_email]
        Spree::Config[:email_admin_list] = params[:email_admin_list]
        crypt = ActiveSupport::MessageEncryptor.new(ENV['shinshu_secret_key'])
        Spree::Config[:gmail_unsubscribe_password] = crypt.encrypt_and_sign(params[:gmail_unsubscribe_password])
        redirect_to action: :show
      end

    end
  end
end
