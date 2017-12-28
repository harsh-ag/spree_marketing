module Spree
  module Admin
    class EmailCampaignsController < ResourceController

      def sync
        Spree::EmailCampaign.sync
        render json: {
          flash: t('.success')
        }, status: 200
      end

      def send_now
        @email_campaign.send_now
        flash[:notice] = 'Emails will be sent now.'
        redirect_to admin_email_campaigns_path
      end

    end
  end
end
