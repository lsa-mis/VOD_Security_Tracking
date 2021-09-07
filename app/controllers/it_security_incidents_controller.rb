class ItSecurityIncidentsController < InheritedResources::Base
  before_action :verify_duo_authentication
  devise_group :logged_in, contains: [:user]
  before_action :authenticate_logged_in!
  before_action :set_it_security_incident, only: [:show, :edit, :update, :archive, :unarchive, :audit_log]
  before_action :add_index_breadcrumb, only: [:index, :show, :new, :edit, :audit_log]
  before_action :set_form_infotext, only: [:new, :edit]
  before_action :set_number_of_items, only: [:index, :audit_log]

  def index
    @it_security_incident_index_text = Infotext.find_by(location: "it_security_incident_index")

    if params[:q].nil?
      @q = ItSecurityIncident.active.ransack(params[:q])
    else
      if params[:q][:incomplete_true].present? && params[:q][:incomplete_true] == "0"
        params[:q] = params[:q].except("incomplete_true")
      end
      @q = ItSecurityIncident.active.ransack(params[:q].try(:merge, m: params[:q][:m]))
    end
    @q.sorts = ["created_at desc"] if @q.sorts.empty?

    if session[:items].present?
      @pagy, @it_security_incidents = pagy(@q.result.distinct, items: session[:items])
    else
      @pagy, @it_security_incidents = pagy(@q.result.distinct)
    end

    @data_type = DataType.where(id: ItSecurityIncident.pluck(:data_type_id).uniq).order(:name)
    @it_security_incident_status = ItSecurityIncidentStatus.where(id: ItSecurityIncident.pluck(:it_security_incident_status_id).uniq).order(:name)

    authorize @it_security_incidents
    # Rendering code will go here
    if params[:format] == "csv"
      it_security_incidents = @q.result.distinct
      respond_to do |format|
        format.html
        format.csv { send_data it_security_incidents.to_csv, filename: "IT Security Incidents-#{Date.today}.csv"}
      end
    else
      unless params[:q].nil?
        render turbo_stream: turbo_stream.replace(
        :it_security_incidentListing,
        partial: "it_security_incidents/listing"
      )
      end
    end

  end

  def show
    add_breadcrumb(@it_security_incident.display_name)
    authorize @it_security_incident
  end

  def new
    add_breadcrumb('New')
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
        format.html { redirect_to it_security_incident_path(@it_security_incident), 
          notice: 'IT Security Incident record was successfully created.' 
        }
      else
        format.html { render :new }
      end
    end
  end

  def edit
    add_breadcrumb(@it_security_incident.display_name, 
        it_security_incident_path(@it_security_incident)
      )
    add_breadcrumb('Edit')
    @tdx_ticket = @it_security_incident.tdx_tickets.new
    authorize @it_security_incident
  end

  def update
    if it_security_incident_params[:tdx_ticket][:ticket_link].present?
      @it_security_incident.tdx_tickets.create(
            ticket_link: it_security_incident_params[:tdx_ticket][:ticket_link]
          )
    end
    respond_to do |format|
      if @it_security_incident.update(it_security_incident_params.except(:tdx_ticket))
        format.html { redirect_to it_security_incident_path(@it_security_incident), 
                      notice: 'IT Security Incident record was successfully updated.' 
                    }
      else
        format.html { render :edit }
      end
    end
  end

  def archive
    authorize @it_security_incident
    respond_to do |format|
      if @it_security_incident.archive
          format.html { redirect_to it_security_incidents_path,
                      notice: 'IT Security Incident record was successfully archived.'
                      }
      else
        format.html { redirect_to it_security_incidents_path,
                     alert: 'Error archiving IT Security Incident record.' 
                    }
      end
    end
  end
  
  def unarchive
    respond_to do |format|
      if @it_security_incident.unarchive
        format.html { redirect_to admin_it_security_incident_path, 
                      notice: 'Record was unarchived.' 
                    }
      end
    end
  end

  def audit_log
    authorize @it_security_incident
    add_breadcrumb(@it_security_incident.display_name, 
                    it_security_incident_path(@it_security_incident)
                  )
    add_breadcrumb('Audit')

    if session[:items].present?
      @pagy, @it_security_incident_audit_log = pagy(@it_security_incident.audits.all.reorder(created_at: :desc), items: session[:items])
    else
      @pagy, @it_security_incident_audit_log = pagy(@it_security_incident.audits.all.reorder(created_at: :desc))
    end

  end

  private

    def set_it_security_incident
      @it_security_incident = ItSecurityIncident.find(params[:id])
    end

    def add_index_breadcrumb
      add_breadcrumb("IT Security Incidents", it_security_incidents_path)
    end

    def set_form_infotext
      @it_security_incident_form_text = Infotext.find_by(location: "it_security_incident_form")
    end

    def set_number_of_items
      if params[:items].present?
        session[:items] = params[:items]
      end
    end

    def it_security_incident_params
      params.require(:it_security_incident).permit(:title, :date, :people_involved,
                    :equipment_involved, :remediation_steps, :estimated_financial_cost,
                    :notes, :it_security_incident_status_id, :data_type_id, :incomplete,
                    :m, attachments: [], tdx_ticket: [:ticket_link])
    end

end
