class ItSecurityIncidentsController < InheritedResources::Base
  devise_group :logged_in, contains: [:user, :admin]
  before_action :authenticate_logged_in!

  def index
    @it_security_incidents = ItSecurityIncident.active
  end

  def archive
    @it_security_incident = ItSecurityIncident.find(params[:id])
    authorize @it_security_incident
    @it_security_incident.archive
    respond_to do |format|
      format.html { redirect_to it_security_incidents_path, notice: 'it security incident record was successfully archived.' }
      format.json { head :no_content }
    end
  end
  
  def audit_log
    @it_security_incidents = ItSecurityIncident.all
  end

  private

    def it_security_incident_params
      params.require(:it_security_incident).permit(:date, :people_involved, :equipment_involved, :remediation_steps, :estimated_finacial_cost, :notes, :it_security_incident_status_id, :data_type_id, attachments: [])
    end

end
