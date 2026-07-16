module Admin
  class StorageLocationsController < BaseController
    include Admin::CrudActions

    private

    def resource_params
      params.require(:storage_location).permit(:name, :description, :description_link, :device_is_required)
    end
  end
end
