module Spree
  class OutOfStockListsController < StoreController

    before_action :load_variant
    before_action :load_out_of_stock_list
    before_action :check_if_already_subscribed

    def subscribe
      @list.create_or_subscribe(params[:email])
      if @list.has_email?(params[:email])
        render json: { message: 'You are signed up!' }
      else
        render json: { error: 'Please try again' }
      end
    end

    private
      def load_variant
        @variant = Spree::Variant.find_by(sku: params[:key])
        unless @variant.present?
          render json: { error: 'oops something is wrong, please try again in some time.' }
        end
      end

      def load_out_of_stock_list
        @list = Spree::OutOfStockList.find_or_create(@variant)
      end

      def check_if_already_subscribed
        @contact = @list.contacts.find_by(email: params[:email])
        if @contact.present?
          render json: { error: 'You are already subscribed' }
        end
      end

  end
end
