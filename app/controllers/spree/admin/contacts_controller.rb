module Spree
  module Admin
    class ContactsController < ResourceController
      def index
        @search = @contacts.ransack(params[:q])
        @contacts = @search.result.uniq.page(params[:page]).per(params[:per_page] || Spree::Config[:admin_orders_per_page])
      end

      def import
        @asset = Spree::ContactFile.new(viewable_type: 'Spree::Contact')
        @asset.attachment = params[:attachment]
        if @asset.save
          flash[:notice] = 'We have recieved your file, Once processed we will mail you status for it'
        else
          flash[:error] = 'There seems to be some issue with your file format please try again.'
        end
        redirect_to admin_contacts_path
      end

      def export
        load_resource
        @search = @contacts.ransack(params[:q])
        @contacts = @search.result
        Spree::ExportService::Contact.new(@contacts, params[:q], try_spree_current_user.email).send_data.delay
        flash[:error] = 'We have recieved your request we will email you with the export within few minutes'
        redirect_to admin_contacts_path
      end

      private
        def collection_actions
          [:index, :export]
        end

        def permitted_resource_params
          params.require(:contact).permit!.merge(data_source: Spree::Contact::VALID_DATA_SOURCES[:website])
        end

        def permit_csv_data
          params
        end
    end
  end
end
