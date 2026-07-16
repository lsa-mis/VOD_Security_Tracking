module Admin
  class DpaExceptionStatusesController < BaseController
    include Admin::CrudActions

    private

    def resource_params
      params.require(:dpa_exception_status).permit(:name, :description)
    end
  end
end
