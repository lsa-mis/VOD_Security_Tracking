class LegacyOsRecordsController < InheritedResources::Base
  devise_group :logged_in, contains: [:user, :admin_user]
  before_action :authenticate_logged_in!

  def index
    @legacy_os_records = LegacyOsRecord.active
  end

  def new
    @legacy_os_record = LegacyOsRecord.new
  end

  def create
    @legacy_os_record = LegacyOsRecord.new(legacy_os_record_params)

    respond_to do |format|
      if @legacy_os_record.save
        format.html { redirect_to root_path, notice: 'legacy os record was successfully created.' }
        format.json { render :show, status: :created, location: @recommendation }
        # dev = @legacy_os_record.build_device(serial: legacy_os_record_params[:device_attributes][:serial])
        # dev.save
      else
        format.html { render :new }
        format.json { render json: @recommendation.errors, status: :unprocessable_entity }
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
      params.require(:legacy_os_record).permit(:owner_username, :owner_full_name, :dept, :phone, :additional_dept_contact, :additional_dept_contact_phone, :support_poc, :legacy_os, :unique_app, :unique_hardware, :unique_date, :remediation, :exception_approval_date, :review_date, :review_contact, :justification, :local_it_support_group, :notes, :data_type_id, :device_id, attachments: [], device_attributes: [:serial, :hostname, :mac, :building, :room, :manufacturer, :model, :owner, :department])
    end

end
