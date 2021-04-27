class ItSecurityIncidents::TdxTicketsController < TdxTicketsController
    before_action :set_record_to_tdx

    private

    def set_record_to_tdx
        @record_to_tdx = ItSecurityIncident.find(params[:it_security_incident_id])
    end

end