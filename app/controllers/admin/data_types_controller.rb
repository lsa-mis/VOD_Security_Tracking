module Admin
  class DataTypesController < BaseController
    include Admin::CrudActions

    private

    def resource_params
      params.require(:data_type).permit(:name, :description, :description_link, :data_classification_level_id)
    end
  end
end
