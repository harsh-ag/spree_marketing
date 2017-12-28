module Spree
  module Admin
    class EmailListsController < ResourceController
      def index
      end

      def create
        if params[:q].blank?
          flash[:error] = 'Please define some parameters to select contacts.'
          redirect_back_or_default(spree.root_path)
        else
          @email_list = EmailList.create_with_options(params[:q])
          if EmailList.create_with_options(params[:q]).persisted?
            redirect_to edit_admin_email_list_path(@email_list)
          else
            redirect_back_or_default(spree.root_path)
          end
        end
      end

      def refresh
        if @email_list.refresh
          flash[:notice] = 'Email list refreshed'
        else
          flash[:error] = 'Could not refresh email list'
        end
        redirect_back_or_default(spree.root_path)
      end

      private

      def permitted_resource_params
        params.require(:email_list).permit(:name)
      end

    end
  end
end
