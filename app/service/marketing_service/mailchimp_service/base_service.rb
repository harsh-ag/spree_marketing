module MarketingService
  module MailchimpService
    class BaseService

      def self.gibbon
        @gibbon ||= ::Gibbon::Request.new(api_key: Spree::Config[:mailchimp_api_key])
      end

      def gibbon
        self.class.gibbon
      end
    end
  end
end
