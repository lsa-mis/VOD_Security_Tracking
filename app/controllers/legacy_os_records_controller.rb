class LegacyOsRecordsController < InheritedResources::Base
  devise_group :logged_in, contains: [:user, :admin_user]
  before_action :authenticate_logged_in!
  include DeviceTdxApi

  def index
    @legacy_os_records = LegacyOsRecord.active
  end

  def new
    @legacy_os_record = LegacyOsRecord.new
  end

  def create
    @legacy_os_record = LegacyOsRecord.new(legacy_os_record_params)
    @serial = legacy_os_record_params[:device_attributes][:serial]
    @hostname = legacy_os_record_params[:device_attributes][:hostname]
    if @serial.present? 
      @search_field = @serial
    else 
      @search_field = @hostname
    end
  
    # check if serial (or hostname) exists in devices table 
    if @serial.present? && Device.find_by(serial: @serial).present?
      @legacy_os_record.device_id = Device.find_by(serial: @serial).id
    elsif @hostname.present? && Device.find_by(hostname: @hostname).present?
      @legacy_os_record.device_id = Device.find_by(hostname: @hostname).id
    else
      # call DeviceTdxApi module
      get_device_data
    end
    respond_to do |format|
      @device_note = "" if @device_note.nil?
      @error_device = "" if @error_device.nil?
      if @error_device.blank?
        if @legacy_os_record.save        
          format.html { redirect_to legacy_os_record_path(@legacy_os_record), notice: 'legacy os record was successfully created. ' + @device_note}
          format.json { render :show, status: :created, location: @legacy_os_record }
        else
          format.html { render :new }
          format.json { render json: @legacy_os_record.errors, status: :unprocessable_entity }
        end
      else
        flash.now[:alert] = @error_device
        format.html { render :new }
        format.json { render json: @legacy_os_record.errors, status: :unprocessable_entity }
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

    def legacy_os_record_params
      # params.require(:legacy_os_record).permit(:owner_username, :owner_full_name, :dept, :phone, :additional_dept_contact, :additional_dept_contact_phone, :support_poc, :legacy_os, :unique_app, :unique_hardware, :unique_date, :remediation, :exception_approval_date, :review_date, :review_contact, :justification, :local_it_support_group, :notes, :data_type_id, :device_id, attachments: [], device_attributes: [:serial, :hostname, :mac, :building, :room, :manufacturer, :model, :owner, :department])
     params.require(:legacy_os_record).permit(:owner_username, :owner_full_name, :dept, :phone, :additional_dept_contact, :additional_dept_contact_phone, :support_poc, :legacy_os, :unique_app, :unique_hardware, :unique_date, :remediation, :exception_approval_date, :review_date, :review_contact, :justification, :local_it_support_group, :notes, :data_type_id, :device_id, :incomplete, attachments: [], device_attributes: [:serial, :hostname])
    end

end
