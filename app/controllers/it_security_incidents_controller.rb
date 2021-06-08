class ItSecurityIncidentsController < InheritedResources::Base
  devise_group :logged_in, contains: [:user, :admin_user]
  before_action :authenticate_logged_in!
  before_action :set_it_security_incident, only: [:show, :edit, :update, :archive]
  before_action :add_index_breadcrumb, only: [:index, :show, :new, :edit]
  before_action :set_membership

  def index
    @it_security_incidents = ItSecurityIncident.active
  end

  def show
    add_breadcrumb(@it_security_incident.id)
  end

  def new
    @it_security_incident = ItSecurityIncident.new
    authorize @it_security_incident
  end

  def create 
    @it_security_incident = ItSecurityIncident.new(it_security_incident_params.except(:tdx_ticket))
    if it_security_incident_params[:tdx_ticket][:ticket_link].present?
      @it_security_incident.tdx_tickets.new(ticket_link: it_security_incident_params[:tdx_ticket][:ticket_link])
    end
    respond_to do |format|
      if @it_security_incident.save 
        format.turbo_stream { redirect_to it_security_incident_path(@it_security_incident), 
          notice: 'it security incident record was successfully created. ' 
        }
      else
        Rails.logger.info(@it_security_incident.errors.inspect)
        format.turbo_stream
      end
    end
  end

  def edit
    add_breadcrumb(@it_security_incident.id, 
        it_security_incident_path(@it_security_incident)
      )
    add_breadcrumb('Edit')
    @tdx_ticket = @it_security_incident.tdx_tickets.new
    authorize @it_security_incident
  end

  def update
    if it_security_incident_params[:tdx_ticket][:ticket_link].present?
      @it_security_incident.tdx_tickets.create(ticket_link: it_security_incident_params[:tdx_ticket][:ticket_link])
    end
    respond_to do |format|
      if @it_security_incident.update(it_security_incident_params.except(:tdx_ticket))
        format.turbo_stream { redirect_to it_security_incident_path(@it_security_incident), notice: 'it security incident record was successfully updated.' }
      else
        format.turbo_stream
      end
    end
  end

  def archive
    authorize @it_security_incident
    if @it_security_incident.archive
      respond_to do |format|
        format.turbo_stream { redirect_to it_security_incidents_path, notice: 'it security incident record was successfully archived.' }
      end
    else
      format.turbo_stream { redirect_to it_security_incidents_path, alert: 'error archiving it security incident record.' }
    end
  end
  
  def audit_log
    @it_security_incidents = ItSecurityIncident.all
  end

  private

    def set_membership
      current_user.membership = session[:user_memberships]
      logger.debug "************ in DPA_EXCEPTION current_user.membership ***** #{current_user.membership}"
    end

    def set_it_security_incident
      @it_security_incident = ItSecurityIncident.find(params[:id])
    end

    def add_index_breadcrumb
      add_breadcrumb(controller_name.titleize, it_security_incidents_path)
    end

    def it_security_incident_params
      params.require(:it_security_incident).permit(:date, :people_involved, :equipment_involved, :remediation_steps, :estimated_finacial_cost, :notes, :it_security_incident_status_id, :data_type_id, :incomplete, attachments: [], tdx_ticket: [:ticket_link])
    end

end
