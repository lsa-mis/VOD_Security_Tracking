class ItSecurityIncidentsController < InheritedResources::Base
  devise_group :logged_in, contains: [:user, :admin_user]
  before_action :authenticate_logged_in!
  before_action :set_it_security_incident, only: [:show, :edit, :update, :archive]
  before_action :add_index_breadcrumb, only: [:index, :show, :new, :edit]

  def index
    @it_security_incidents = ItSecurityIncident.active
  end

  def show
    add_breadcrumb(@it_security_incident.id)
  end

  def update
    respond_to do |format|
      if @it_security_incident.update(it_security_incident_params)
        format.html { redirect_to it_security_incident_path(@it_security_incident), notice: 'it security incident record was successfully updated.' }
        format.json { render :show, status: :created, location: @it_security_incident }
      else
        format.html { render :new }
        format.json { render json: @it_security_incident.errors, status: :unprocessable_entity }
      end
    end
  end

  def archive
    authorize @it_security_incident
    if @it_security_incident.archive
      respond_to do |format|
        format.html { redirect_to it_security_incidents_path, notice: 'it security incident record was successfully archived.' }
        format.json { head :no_content }
      end
    else
      format.html { redirect_to it_security_incidents_path, alert: 'error archiving it security incident record.' }
      format.json { head :no_content }
    end
  end
  
  def audit_log
    @it_security_incidents = ItSecurityIncident.all
  end

  private

  def set_it_security_incident
    @it_security_incident = ItSecurityIncident.find(params[:id])
  end

  def add_index_breadcrumb
    add_breadcrumb(controller_name.titleize, it_security_incidents_path)
  end

  def it_security_incident_params
    params.require(:it_security_incident).permit(:date, :people_involved, :equipment_involved, :remediation_steps, :estimated_finacial_cost, :notes, :it_security_incident_status_id, :data_type_id, :incomplete, attachments: [])
  end

end
