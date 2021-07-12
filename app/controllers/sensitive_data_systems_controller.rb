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

    if params[:items].present?
      session[:items] = params[:items]
    end

    if params[:q].nil?
      @q = SensitiveDataSystem.active.ransack(params[:q])
    else
      if params[:q][:data_type_id_blank].present? && params[:q][:data_type_id_blank] == "0"
        params[:q] = params[:q].except("data_type_id_blank")
      end
      if params[:q][:storage_location_id_blank].present? && params[:q][:storage_location_id_blank] == "0"
        params[:q] = params[:q].except("storage_location_id_blank")
      end
      @q = SensitiveDataSystem.active.ransack(params[:q].try(:merge, m: params[:q][:m]))
    end
    @q.sorts = ["id asc"] if @q.sorts.empty?
    if session[:items].present?
      @pagy, @sensitive_data_systems = pagy(@q.result, items: session[:items])
    else
      @pagy, @sensitive_data_systems = pagy(@q.result)
    end
    @owner_username = @sensitive_data_systems.pluck(:owner_username).uniq
    @dept = @sensitive_data_systems.pluck(:dept).uniq
    @additional_dept_contact = @sensitive_data_systems.pluck(:additional_dept_contact).uniq.compact_blank
    @data_type = DataType.where(id: SensitiveDataSystem.pluck(:data_type_id).uniq)
    @storage_location = StorageLocation.where(id: SensitiveDataSystem.pluck(:storage_location_id).uniq)
    @device_serial = Device.where(id: SensitiveDataSystem.pluck(:device_id).uniq).where.not(serial: [nil, ""])
    @device_hostname = Device.where(id: SensitiveDataSystem.pluck(:device_id).uniq).where.not(hostname: [nil, ""])

    

    authorize @sensitive_data_systems

    unless params[:q].nil?
      render turbo_stream: turbo_stream.replace(
      :sensitive_data_systemListing,
      partial: "sensitive_data_systems/listing"
    )
    end
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
    @sensitive_data_system = SensitiveDataSystem.new(sensitive_data_system_params.except(:device_attributes, :tdx_ticket))
    if sensitive_data_system_params[:tdx_ticket][:ticket_link].present?
      @sensitive_data_system.tdx_tickets.new(ticket_link: sensitive_data_system_params[:tdx_ticket][:ticket_link])
    end
    @note = ""
    serial = sensitive_data_system_params[:device_attributes][:serial]
    hostname = sensitive_data_system_params[:device_attributes][:hostname]
    if serial.present? || hostname.present?
      device_class = DeviceManagment.new(serial, hostname)
      if device_class.create_device || device_class.device_exist?
        @sensitive_data_system.device = device_class.device
        @note ||= device_class.message || ""
      else
        flash.now[:alert] = device_class.message
        render turbo_stream: turbo_stream.update("flash", partial: "layouts/notification")
        return
      end
    end
    respond_to do |format|
      if @sensitive_data_system.save 
        format.turbo_stream { redirect_to sensitive_data_system_path(@sensitive_data_system), notice: 'Sensitive Data System record was successfully created. ' + @note }
      else
        format.turbo_stream
      end
    end
  end

  def edit
    add_breadcrumb(@sensitive_data_system.id, 
        sensitive_data_system_path(@sensitive_data_system)
      )
    add_breadcrumb('Edit')
    @tdx_ticket = @sensitive_data_system.tdx_tickets.new
    if @sensitive_data_system.device_id.nil?
      @device = Device.new
    end
    authorize @sensitive_data_system
  end

  def update
    if sensitive_data_system_params[:tdx_ticket][:ticket_link].present?
      @sensitive_data_system.tdx_tickets.create(ticket_link: sensitive_data_system_params[:tdx_ticket][:ticket_link])
    end
    @note = ""
    if sensitive_data_system_params[:storage_location_id].present? && StorageLocation.find(sensitive_data_system_params[:storage_location_id]).device_is_required
      serial = sensitive_data_system_params[:device_attributes][:serial]
      hostname = sensitive_data_system_params[:device_attributes][:hostname]
      device_class = DeviceManagment.new(serial, hostname)
      if device_class.device_exist?
        @sensitive_data_system.device_id = device_class.device.id
      elsif device_class.create_device
        # need to save device
        device = device_class.device
        @note ||= device_class.message || ""
        if device.save
          @sensitive_data_system.device_id = device.id
        else
          flash.now[:alert] = "Error saving device"
          render turbo_stream: turbo_stream.update("flash", partial: "layouts/notification")
          return
        end
      else
        flash.now[:alert] = device_class.message
        render turbo_stream: turbo_stream.update("flash", partial: "layouts/notification")
        return
      end
    else
      @sensitive_data_system.device_id = nil
    end
    respond_to do |format|
      if @sensitive_data_system.update(sensitive_data_system_params.except(:device_attributes, :tdx_ticket))
        format.turbo_stream { redirect_to sensitive_data_system_path(@sensitive_data_system), notice: 'Sensitive Data System record was successfully updated. ' + @note }
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
                                                    :sensitive_data_system_type_id, :incomplete, :m,
                                                    attachments: [], 
                                                    device_attributes: [:serial, :hostname], 
                                                    tdx_ticket: [:ticket_link]
                                                  )
    end

end
