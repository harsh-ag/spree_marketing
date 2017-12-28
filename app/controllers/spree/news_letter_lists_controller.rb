module Spree
  class NewsLetterListsController < StoreController

    before_action :load_newsletter
    before_action :check_if_already_subscribed, only: :subscribe

    def subscribe
      if @newsletter.create_or_subscribe(params[:email])
        render json: { message: 'You are signed up!' }
      else
        render json: { error: 'Please try again' }
      end
    end

    #confirmation page
    def unsubscribe
      @unsubscribe_email_id = params[:email]
      #render the page
    end

    def unsubscribe_action
      if params[:email].present?
        #real action
        @newsletter.unsubscribe(params[:email])
        @success=true
      else
        @success=false
      end
      #render
    end

    private
      def load_newsletter
        @newsletter = Spree::NewsLetterList.default
        unless @newsletter.present?
          render json: { error: 'oops something is wrong, please try again in some time.' }
        end
      end

      def check_if_already_subscribed
        @contact = @newsletter.contacts.find_by(email: params[:email])
        if @contact.present? && @contact.subscribed?
          #contact exists, added to email_lists and subscribe flat is true
          render json: { error: 'You are already subscribed' }
        end
      end

  end
end
