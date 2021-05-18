class LegacyOsRecordsController < InheritedResources::Base
  devise_group :logged_in, contains: [:user, :admin_user]
  before_action :authenticate_logged_in!
  before_action :set_legacy_os_record, only: [:show, :edit, :update, :archive]
  before_action :get_access_token, only: [:create, :update]

  include SaveRecordWithDevice

  def index
    @legacy_os_records = LegacyOsRecord.active
  end

  def edit
    @device = @legacy_os_record.device
  end

  def new
    @legacy_os_record = LegacyOsRecord.new
    @device = Device.new
  end

  def create
    @legacy_os_record = LegacyOsRecord.new(legacy_os_record_params)
    @device = @legacy_os_record.build_device 
    serial = legacy_os_record_params[:device_attributes][:serial]
    hostname = legacy_os_record_params[:device_attributes][:hostname]

    if serial.present? 
      if Device.find_by(serial: serial).present?
        @legacy_os_record.device_id = Device.find_by(serial: serial).id
      else 
        search_field = serial
      end
    elsif hostname.present? 
      if Device.find_by(hostname: hostname).present?
        @legacy_os_record.device_id = Device.find_by(hostname: hostname).id
      else
        search_field = hostname
      end
    else
      respond_to do |format|
        flash.now[:alert] = "Serial or hostname should be present"
        format.html { render :new }
        format.json { render json: @device.errors, status: :unprocessable_entity }
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
      save_with_device(@legacy_os_record, @device_tdx_info, 'legacy_os_record')
    else
      respond_to do |format|
        if @legacy_os_record.save 
          format.html { redirect_to legacy_os_record_path(@legacy_os_record), notice: 'Legacy os record was successfully created. ' }
          format.json { render :show, status: :created, location: @legacy_os_record }
        else
          format.html { render :new }
          format.json { render json: @legacy_os_record.errors, status: :unprocessable_entity }
        end
      end
    end
  end

  def archive
    @legacy_os_record = LegacyOsRecord.find(params[:id])
    authorize @legacy_os_record
    if @legacy_os_record.archive
      respond_to do |format|
        format.html { redirect_to legacy_os_records_path, notice: 'legacy os record was successfully archived.' }
        format.json { head :no_content }
      end
    else
      format.html { redirect_to legacy_os_records_path, alert: 'error archiving legacy os record.' }
      format.json { head :no_content }
    end
  end
  
  def audit_log
    @legacy_os_records = LegacyOsRecord.all
  end

  private

    def set_legacy_os_record
      @legacy_os_record = LegacyOsRecord.find(params[:id])
    end

    def get_access_token
      auth_token = AuthTokenApi.new
      @access_token = auth_token.get_auth_token
    end

    def get_device_tdx_info(search_field, access_token)
      device_tdx = DeviceTdxApi.new(search_field, access_token)
      @device_tdx_info = device_tdx.get_device_data
    end

    def legacy_os_record_params
      params.require(:legacy_os_record).permit(:owner_username, :owner_full_name, :dept, :phone, :additional_dept_contact, :additional_dept_contact_phone, :support_poc, :legacy_os, :unique_app, :unique_hardware, :unique_date, :remediation, :exception_approval_date, :review_date, :review_contact, :justification, :local_it_support_group, :notes, :data_type_id, :device_id, :incomplete, attachments: [], device_attributes: [:serial, :hostname])
    end

end
