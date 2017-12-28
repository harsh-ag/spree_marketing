module Spree
  module Api
    module V1
      class LabelsController < Spree::Api::BaseController
        def index
          @labels =
            if params[:ids]
              Spree::EmailLabel.where(id: params[:ids].split(",").flatten)
            else
              Spree::EmailLabel.ransack(params[:q]).result
            end

          @labels = @labels.page(params[:page]).per(params[:per_page])
          render json: { labels: @labels.as_json }
        end

        private

        def tags_params
          params.require(:tag).permit(:name, :id)
        end
      end
    end
  end
end
