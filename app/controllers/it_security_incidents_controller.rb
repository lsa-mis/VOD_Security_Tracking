class ItSecurityIncidentsController < InheritedResources::Base
  devise_group :logged_in, contains: [:user, :admin_user]
  before_action :authenticate_logged_in!
  before_action :set_it_security_incident, only: [:show, :edit, :update, :archive, :audit_log]
  before_action :add_index_breadcrumb, only: [:index, :show, :new, :edit, :audit_log]
  before_action :set_membership

  def index
    @it_security_incidents = ItSecurityIncident.active
    authorize @it_security_incidents
  end

  def show
    add_breadcrumb(@it_security_incident.id)
    authorize @it_security_incident
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
          notice: 'IT Security Incident record was successfully created.' 
        }
      else
        # Rails.logger.info(@it_security_incident.errors.inspect)
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
        format.turbo_stream { redirect_to it_security_incident_path(@it_security_incident), notice: 'IT Security Incident record was successfully updated.' }
      else
        format.turbo_stream
      end
    end
  end

  def archive
    authorize @it_security_incident
    respond_to do |format|
      if @it_security_incident.archive
          format.turbo_stream { redirect_to it_security_incidents_path,
                      notice: 'IT Security Incident record was successfully archived.'
                    }
      else
        format.turbo_stream { redirect_to it_security_incidents_path,
                    alert: 'Error archiving IT Security Incident record.' 
                  }
      end
    end
  end
  
  def audit_log
    authorize @it_security_incident
    add_breadcrumb(@it_security_incident.id, 
      it_security_incident_path(@it_security_incident)
                  )
    add_breadcrumb('Audit')

    @it_si_item_audit_log = @it_security_incident.audits.all.reorder(created_at: :desc)
  end

  private

  def set_membership
    if user_signed_in?
      current_user.membership = session[:user_memberships]
    else
      redirect_to root_path
    end
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
