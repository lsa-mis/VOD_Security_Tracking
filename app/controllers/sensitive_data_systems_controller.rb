class SensitiveDataSystemsController < InheritedResources::Base
  before_action :verify_duo_authentication
  devise_group :logged_in, contains: [:user, :admin_user]
  before_action :authenticate_logged_in!
  before_action :set_sensitive_data_system, only: [:show, :edit, :update, :archive, :audit_log]
  before_action :get_access_token, only: [:create, :update]
  before_action :add_index_breadcrumb, only: [:index, :show, :new, :edit, :audit_log]
  before_action :set_membership

  include SaveRecordWithDevice

  def index
    @sensitive_data_systems = SensitiveDataSystem.active
    authorize @sensitive_data_systems
  end

  def show
    add_breadcrumb(@sensitive_data_system.id)
    authorize @sensitive_data_system
  end

  def new
    @sensitive_data_system = SensitiveDataSystem.new
    @device = Device.new
    authorize @sensitive_data_system
  end

  def create
    if sensitive_data_system_params[:sensitive_data_system_type_id] == "1"
      @sensitive_data_system = SensitiveDataSystem.new(sensitive_data_system_params.except(:tdx_ticket))
      if sensitive_data_system_params[:tdx_ticket][:ticket_link].present?
        @sensitive_data_system.tdx_tickets.new(ticket_link: sensitive_data_system_params[:tdx_ticket][:ticket_link])
      end
      serial = sensitive_data_system_params[:device_attributes][:serial]
      hostname = sensitive_data_system_params[:device_attributes][:hostname]
      # find device
      if serial.present? 
        if Device.find_by(serial: serial).present?
          @sensitive_data_system.device_id = Device.find_by(serial: serial).id
        else 
          search_field = serial
        end
      elsif hostname.present? 
        if Device.find_by(hostname: hostname).present?
          @sensitive_data_system.device_id = Device.find_by(hostname: hostname).id
        else
          search_field = hostname
        end
      end
    else 
      @sensitive_data_system = SensitiveDataSystem.new(sensitive_data_system_params.except(:device_attributes, :tdx_ticket))
      if sensitive_data_system_params[:tdx_ticket][:ticket_link].present?
        @sensitive_data_system.tdx_tickets.new(ticket_link: sensitive_data_system_params[:tdx_ticket][:ticket_link])
      end
    end
    if search_field.present? 
      # call DeviceTdxApi
      if @access_token
        # auth_token exists - call TDX
        @device_tdx_info = get_device_tdx_info(search_field, @access_token)
      else
        # no token - create a device without calling TDX
        @device_tdx_info = {'result' => {'device_not_in_tdx' => "No access to TDX API." }}
      end
      save_with_device(@sensitive_data_system, @device_tdx_info, 'sensitive_data_system')
    else
      respond_to do |format|
        if @sensitive_data_system.save 
          format.turbo_stream { redirect_to sensitive_data_system_path(@sensitive_data_system), notice: 'Sensitive Data System record was successfully created.' }
        else
          format.turbo_stream
        end
      end
    end
  end

  def edit
    add_breadcrumb(@sensitive_data_system.id, 
        sensitive_data_system_path(@sensitive_data_system)
      )
    add_breadcrumb('Edit')
    @tdx_ticket = @sensitive_data_system.tdx_tickets.new
    authorize @sensitive_data_system
  end

  def update
    if sensitive_data_system_params[:tdx_ticket][:ticket_link].present?
      @sensitive_data_system.tdx_tickets.create(ticket_link: sensitive_data_system_params[:tdx_ticket][:ticket_link])
    end
    respond_to do |format|
      if @sensitive_data_system.update(sensitive_data_system_params.except(:tdx_ticket))
        format.turbo_stream { redirect_to sensitive_data_system_path(@sensitive_data_system), notice: 'legacy os record was successfully updated.' }
      else
        format.turbo_stream
      end
    end
  end

  def archive
    @sensitive_data_system = SensitiveDataSystem.find(params[:id])
    authorize @sensitive_data_system
    respond_to do |format|
      if @sensitive_data_system.archive
        format.turbo_stream { redirect_to sensitive_data_systems_path, notice: 'Sensitive Data System record was successfully archived.' }
      else
        format.turbo_stream { redirect_to sensitive_data_systems_path, alert: 'Error archiving Sensitive Data System record.' }
      end
    end
  end
  
  def audit_log
    authorize @sensitive_data_system
    add_breadcrumb(@sensitive_data_system.id, 
      sensitive_data_system_path(@sensitive_data_system)
                  )
    add_breadcrumb('Audit')

    @sensitive_ds_item_audit_log = @sensitive_data_system.audits.all.reorder(created_at: :desc)
  end

  private

    def set_sensitive_data_system
      @sensitive_data_system = SensitiveDataSystem.find(params[:id])
    end
    
    def get_access_token
      auth_token = AuthTokenApi.new
      @access_token = auth_token.get_auth_token
    end

    def get_device_tdx_info(search_field, access_token)
      device_tdx = DeviceTdxApi.new(search_field, access_token)
      @device_tdx_info = device_tdx.get_device_data
    end

    def add_index_breadcrumb
      add_breadcrumb(controller_name.titleize, sensitive_data_systems_path)
    end

    def sensitive_data_system_params
      params.require(:sensitive_data_system).permit(:owner_username, :owner_full_name, 
                                                    :dept, :phone, :additional_dept_contact, 
                                                    :additional_dept_contact_phone, :support_poc, 
                                                    :expected_duration_of_data_retention, 
                                                    :agreements_related_to_data_types, 
                                                    :review_date, :review_contact, :notes, 
                                                    :storage_location_id, :data_type_id, 
                                                    :sensitive_data_system_type_id, :incomplete, 
                                                    attachments: [], 
                                                    device_attributes: [:serial, :hostname], 
                                                    tdx_ticket: [:ticket_link]
                                                  )
    end

end
