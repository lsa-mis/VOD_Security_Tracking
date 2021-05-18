class SensitiveDataSystemsController < InheritedResources::Base
  devise_group :logged_in, contains: [:user, :admin_user]
  before_action :authenticate_logged_in!
  before_action :set_sensitive_data_system, only: [:show, :edit, :update, :archive]
  before_action :get_access_token, only: [:create, :update]

  include SaveRecordWithDevice

  def index
    @sensitive_data_systems = SensitiveDataSystem.active
  end

  def new
    @sensitive_data_system = SensitiveDataSystem.new
    @device = Device.new
  end

  def create
    if sensitive_data_system_params[:sensitive_data_system_type_id] == "1"
      @sensitive_data_system = SensitiveDataSystem.new(sensitive_data_system_params)
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
      @sensitive_data_system = SensitiveDataSystem.new(sensitive_data_system_params.except(:device_attributes))
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
          format.html { redirect_to sensitive_data_system_path(@sensitive_data_system), notice: 'Sensitive data system record was successfully created. ' }
          format.json { render :show, status: :created, location: @sensitive_data_system }
        else
          format.html { render :new }
          format.json { render json: @legacy_os_record.errors, status: :unprocessable_entity }
        end
      end
    end
  end

  def archive
    @sensitive_data_system = SensitiveDataSystem.find(params[:id])
    authorize @sensitive_data_system
    if @sensitive_data_system.archive
      respond_to do |format|
        format.html { redirect_to sensitive_data_systems_path, notice: 'Sensitive data system record was successfully archived.' }
        format.json { head :no_content }
      end
    else
      format.html { redirect_to sensitive_data_systems_path, alert: 'Error archiving sensitive data system record.' }
      format.json { head :no_content }
    end
  end
  
  def audit_log
    @sensitive_data_systems = SensitiveDataSystem.all
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

    def sensitive_data_system_params
      params.require(:sensitive_data_system).permit(:owner_username, :owner_full_name, :dept, :phone, :additional_dept_contact, :additional_dept_contact_phone, :support_poc, :expected_duration_of_data_retention, :agreements_related_to_data_types, :review_date, :review_contact, :notes, :storage_location_id, :data_type_id, :sensitive_data_system_type_id, :incomplete, attachments: [], device_attributes: [:serial, :hostname])
    end

end
