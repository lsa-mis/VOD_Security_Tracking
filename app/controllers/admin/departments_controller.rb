module Admin
  class DepartmentsController < BaseController
    include Admin::CrudActions

    private

    def resource_params
      params.require(:department).permit(:name, :shortname, :active_dir_group)
    end
  end
end
