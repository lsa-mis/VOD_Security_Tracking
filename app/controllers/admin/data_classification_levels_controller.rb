module Admin
  class DataClassificationLevelsController < BaseController
    include Admin::CrudActions

    private

    def resource_params
      params.require(:data_classification_level).permit(:name, :description)
    end
  end
end
