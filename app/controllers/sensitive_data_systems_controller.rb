class SensitiveDataSystemsController < InheritedResources::Base
  before_action :verify_duo_authentication
  devise_group :logged_in, contains: [:user]
  before_action :authenticate_logged_in!
  before_action :set_sensitive_data_system, only: [:show, :edit, :update, :archive, :unarchive, :audit_log]
  before_action :get_access_token, only: [:create, :update]
  before_action :add_index_breadcrumb, only: [:index, :show, :new, :edit, :audit_log]
  before_action :set_form_infotext, only: [:new, :edit]
  before_action :set_number_of_items, only: [:index, :audit_log]
  before_action :set_departments_list, only: [:new, :create, :edit, :update]

  def index
    @sensitive_data_system_index_text = Infotext.find_by(location: "sensitive_data_system_index")
    if params[:items].present?
      session[:items] = params[:items]
    end

    if current_user.dept_membership.any?
      depts_ids = Department.where(active_dir_group: current_user.dept_membership).ids
      sensitive_data_systems_all = SensitiveDataSystem.active.where(department_id: depts_ids)
      # a list of departments to use in filters
      @department = Department.where(id: (SensitiveDataSystem.pluck(:department_id).uniq & depts_ids)).order(:name)
    else
      sensitive_data_systems_all = SensitiveDataSystem.active
      @department = Department.where(id: (SensitiveDataSystem.pluck(:department_id).uniq)).order(:name)
    end

    if params[:q].nil?
      @q = sensitive_data_systems_all.ransack(params[:q])
    else
      if params[:q][:data_type_id_blank].present? && params[:q][:data_type_id_blank] == "0"
        params[:q] = params[:q].except("data_type_id_blank")
      end
      if params[:q][:storage_location_id_blank].present? && params[:q][:storage_location_id_blank] == "0"
        params[:q] = params[:q].except("storage_location_id_blank")
      end
      if params[:q][:incomplete_true].present? && params[:q][:incomplete_true] == "0"
        params[:q] = params[:q].except("incomplete_true")
      end
      @q = sensitive_data_systems_all.ransack(params[:q].try(:merge, m: params[:q][:m]))
    end
    @q.sorts = ["created_at desc"] if @q.sorts.empty?
    if session[:items].present?
      @pagy, @sensitive_data_systems = pagy(@q.result, items: session[:items])
    else
      @pagy, @sensitive_data_systems = pagy(@q.result)
    end
    @owner_username = @sensitive_data_systems.pluck(:owner_username).uniq.sort_by(&:downcase)
    @additional_dept_contact = @sensitive_data_systems.pluck(:additional_dept_contact).uniq.compact_blank.sort_by(&:downcase)
    @data_type = DataType.where(id: SensitiveDataSystem.pluck(:data_type_id).uniq).order(:name)
    @storage_location = StorageLocation.where(id: SensitiveDataSystem.pluck(:storage_location_id).uniq).order(:name)
    @device_serial = Device.where(id: SensitiveDataSystem.pluck(:device_id).uniq).where.not(serial: [nil, ""]).order(:serial)
    @device_hostname = Device.where(id: SensitiveDataSystem.pluck(:device_id).uniq).where.not(hostname: [nil, ""]).order(:hostname)

    authorize @sensitive_data_systems
    # Rendering code will go here
    if params[:format] == "csv"
      respond_to do |format|
        format.html
        format.csv { send_data @sensitive_data_systems.to_csv, filename: "Sensitive Data Systems-#{Date.today}.csv"}
      end
    else
      unless params[:q].nil?
        render turbo_stream: turbo_stream.replace(
        :sensitive_data_systemListing,
        partial: "sensitive_data_systems/listing"
      )
      end
    end
  end

  def show
    add_breadcrumb(@sensitive_data_system.display_name)
    authorize @sensitive_data_system
  end

  def new
    add_breadcrumb('New')
    @sensitive_data_system = SensitiveDataSystem.new
    @device = Device.new
    authorize @sensitive_data_system
  end

  def create
    @note = ''
    @sensitive_data_system = SensitiveDataSystem.new(sensitive_data_system_params.except(:device_attributes, :tdx_ticket))
    if sensitive_data_system_params[:tdx_ticket][:ticket_link].present?
      @sensitive_data_system.tdx_tickets.new(ticket_link: sensitive_data_system_params[:tdx_ticket][:ticket_link])
    end
    serial = sensitive_data_system_params[:device_attributes][:serial]
    hostname = sensitive_data_system_params[:device_attributes][:hostname]
    if serial.present? || hostname.present?
      device_class = DeviceManagment.new(serial, hostname)
      if device_class.create_device || device_class.device_exist?
        @sensitive_data_system.device = device_class.device
        @note ||= device_class.message || ""
        @note = "" if device_class.device_exist?
      else
        # TDX search returns too many results for entered serial or hostname
        @sensitive_data_system.errors.add(:device, device_class.message)
        @sensitive_data_system.device = Device.new(sensitive_data_system_params[:device_attributes])
        render :new
        return
      end
    end
    respond_to do |format|
      if @sensitive_data_system.save 
        format.html { redirect_to sensitive_data_system_path(@sensitive_data_system), notice: 'Sensitive Data System record was successfully created. ' + @note }
      else
        format.html { render :new }
      end
    end
  end

  def edit
    add_breadcrumb(@sensitive_data_system.display_name, 
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
    @note = ''
    if sensitive_data_system_params[:tdx_ticket][:ticket_link].present?
      @sensitive_data_system.tdx_tickets.create(ticket_link: sensitive_data_system_params[:tdx_ticket][:ticket_link])
    end
    if sensitive_data_system_params[:storage_location_id].present? && StorageLocation.find(sensitive_data_system_params[:storage_location_id]).device_is_required
      serial = sensitive_data_system_params[:device_attributes][:serial]
      hostname = sensitive_data_system_params[:device_attributes][:hostname]
      device_class = DeviceManagment.new(serial, hostname)
      if device_class.device_exist?
        @sensitive_data_system.device_id = device_class.device.id
        @note = ""
      elsif device_class.create_device
        # need to save device
        device = device_class.device
        @note = device_class.message
        if device.save
          @sensitive_data_system.device_id = device.id
        else
          @sensitive_data_system.errors.add(:device, "Error saving device")
          @sensitive_data_system.device = Device.new(sensitive_data_system_params[:device_attributes])
          render :edit
          return
        end
      else
        # TDX search returns too many results for entered serial or hostname
        @sensitive_data_system.errors.add(:device, device_class.message)
        if sensitive_data_system_params[:storage_location_id].present?
          @sensitive_data_system.storage_location_id = sensitive_data_system_params[:storage_location_id]
          @sensitive_data_system.device = Device.new(sensitive_data_system_params[:device_attributes])
        end
        render :edit
        return
      end
    else
      @sensitive_data_system.device_id = nil
    end
    respond_to do |format|
      if @sensitive_data_system.update(sensitive_data_system_params.except(:device_attributes, :tdx_ticket))
        format.html { redirect_to sensitive_data_system_path(@sensitive_data_system), notice: 'Sensitive Data System record was successfully updated. ' + @note }
      else
        format.html { render :edit }
      end
    end
  end

  def archive
    @sensitive_data_system = SensitiveDataSystem.find(params[:id])
    authorize @sensitive_data_system
    respond_to do |format|
      if @sensitive_data_system.archive
        format.html { redirect_to sensitive_data_systems_path, notice: 'Sensitive Data System record was successfully archived.' }
      else
        format.html { redirect_to sensitive_data_systems_path, alert: 'Error archiving Sensitive Data System record.' }
      end
    end
  end
 
  def unarchive
    respond_to do |format|
      if @sensitive_data_system.unarchive
        format.html { redirect_to admin_sensitive_data_system_path, 
                      notice: 'Record was unarchived.' 
                    }
      end
    end
  end

  def audit_log
    authorize @sensitive_data_system
    add_breadcrumb(@sensitive_data_system.display_name, 
      sensitive_data_system_path(@sensitive_data_system)
                  )
    add_breadcrumb('Audit')

    if session[:items].present?
      @pagy, @sensitive_data_system_audit_log = pagy(@sensitive_data_system.audits.all.reorder(created_at: :desc), items: session[:items])
    else
      @pagy, @sensitive_data_system_audit_log = pagy(@sensitive_data_system.audits.all.reorder(created_at: :desc))
    end

  end

  private

    def set_sensitive_data_system
      @sensitive_data_system = SensitiveDataSystem.find(params[:id])
    end
    
    def set_departments_list
      # a list of departments to use in new/edit record
      if current_user.dept_membership.any?
        @departments_list = Department.where(active_dir_group: current_user.dept_membership).order(:name)
      else
        @departments_list = Department.all.order(:name)
      end
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

    def set_form_infotext
      @sensitive_data_system_form_text = Infotext.find_by(location: "sensitive_data_system_form")
    end

    def set_number_of_items
      if params[:items].present?
        session[:items] = params[:items]
      end
    end

    def sensitive_data_system_params
      params.require(:sensitive_data_system).permit(:name, :owner_username, :owner_full_name, 
                                                    :department_id, :phone, :additional_dept_contact, 
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
