class ItSecurityIncidents::TdxTicketsController < TdxTicketsController
    before_action :set_records_to_tdx

    private

    def set_records_to_tdx
        @records_to_tdx = ItSecurityIncident.find(params[:it_security_incident_id])
    end

end