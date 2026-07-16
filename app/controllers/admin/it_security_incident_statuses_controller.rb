module Admin
  class ItSecurityIncidentStatusesController < BaseController
    include Admin::CrudActions

    private

    def resource_params
      params.require(:it_security_incident_status).permit(:name, :description)
    end
  end
end
