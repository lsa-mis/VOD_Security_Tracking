class ItSecurityIncidentsController < InheritedResources::Base

  private

    def it_security_incident_params
      params.require(:it_security_incident).permit(:date, :people_involved, :equipment_involved, :remediation_steps, :estimated_finacial_cost, :notes, :it_security_incident_status_id, :data_type_id, attachments: [])
    end

end
