class LegacyOsRecordsController < InheritedResources::Base
  before_action :verify_duo_authentication
  devise_group :logged_in, contains: [:user, :admin_user]
  before_action :authenticate_logged_in!
  before_action :set_legacy_os_record, only: [:show, :edit, :update, :archive, :audit_log]
  before_action :get_access_token, only: [:create, :update]
  before_action :add_index_breadcrumb, only: [:index, :show, :new, :edit, :audit_log]
  before_action :set_form_infotext, only: [:new, :edit]
  before_action :set_number_of_items, only: [:index, :audit_log]

  def index
    @legacy_os_record_index_text = Infotext.find_by(location: "legacy_os_record_index")
    if params[:items].present?
      session[:items] = params[:items]
    end

    if params[:q].nil?
      @q = LegacyOsRecord.active.ransack(params[:q])
    else
      if params[:q][:data_type_id_blank].present? && params[:q][:data_type_id_blank] == "0"
        params[:q] = params[:q].except("data_type_id_blank")
      end
      if params[:q][:incomplete_true].present? && params[:q][:incomplete_true] == "0"
        params[:q] = params[:q].except("incomplete_true")
      end
      @q = LegacyOsRecord.active.ransack(params[:q].try(:merge, m: params[:q][:m]))
    end
    @q.sorts = ["created_at desc"] if @q.sorts.empty?
    if session[:items].present?
      @pagy, @legacy_os_records = pagy(@q.result, items: session[:items])
    else
      @pagy, @legacy_os_records = pagy(@q.result)
    end
    @owner_username = @legacy_os_records.pluck(:owner_username).uniq.compact
    @dept = @legacy_os_records.pluck(:dept).uniq
    @additional_dept_contact = @legacy_os_records.pluck(:additional_dept_contact).uniq.compact_blank
    @legacy_os = @legacy_os_records.pluck(:legacy_os).uniq.compact_blank
    @review_contact = @legacy_os_records.pluck(:review_contact).uniq.compact_blank
    @local_it_support_group = @legacy_os_records.pluck(:local_it_support_group).uniq.compact_blank
    @data_type = DataType.where(id: LegacyOsRecord.pluck(:data_type_id).uniq)
    @device_serial = Device.where(id: LegacyOsRecord.pluck(:device_id).uniq).where.not(serial: [nil, ""])
    @device_hostname = Device.where(id: LegacyOsRecord.pluck(:device_id).uniq).where.not(hostname: [nil, ""])
    
    authorize @legacy_os_records

    unless params[:q].nil?
      render turbo_stream: turbo_stream.replace(
      :legacy_os_recordListing,
      partial: "legacy_os_records/listing"
    )
    end
  end

  def show
    add_breadcrumb(@legacy_os_record.device.display_hostname)
    authorize @legacy_os_record
  end

  def new
    @legacy_os_record = LegacyOsRecord.new
    @device = Device.new
    authorize @legacy_os_record
  end

  def create
    @legacy_os_record = LegacyOsRecord.new(legacy_os_record_params.except(:tdx_ticket, :device_attributes))
    if legacy_os_record_params[:tdx_ticket][:ticket_link].present?
      @legacy_os_record.tdx_tickets.new(ticket_link: legacy_os_record_params[:tdx_ticket][:ticket_link])
    end
    serial = legacy_os_record_params[:device_attributes][:serial]
    hostname = legacy_os_record_params[:device_attributes][:hostname]
    device_class = DeviceManagment.new(serial, hostname)
    
    if device_class.create_device || device_class.device_exist?
      @legacy_os_record.device = device_class.device
      @note ||= device_class.message || ""
      @note = "" if device_class.device_exist?
    else
      flash.now[:alert] = device_class.message
      render turbo_stream: turbo_stream.update("flash", partial: "layouts/notification")
      return
    end

    respond_to do |format|
      if @legacy_os_record.save 
        format.turbo_stream { redirect_to legacy_os_record_path(@legacy_os_record), 
        notice: 'Legacy OS record was successfully created. ' + @note
      }
      else
        format.turbo_stream
      end
    end
    
  end

  def edit
    add_breadcrumb(@legacy_os_record.display_name, 
      legacy_os_record_path(@legacy_os_record)
    )
    add_breadcrumb('Edit')
    authorize @legacy_os_record
  end

  def update
    if legacy_os_record_params[:tdx_ticket][:ticket_link].present?
      @legacy_os_record.tdx_tickets.create(ticket_link: legacy_os_record_params[:tdx_ticket][:ticket_link])
    end
    serial = legacy_os_record_params[:device_attributes][:serial]
    hostname = legacy_os_record_params[:device_attributes][:hostname]
    device_class = DeviceManagment.new(serial, hostname)

    if device_class.device_exist?
      @legacy_os_record.device_id = device_class.device.id
      @note = ""
    elsif device_class.create_device
      # need to save device
      device = device_class.device
      @note ||= device_class.message || ""
      if device.save
        @legacy_os_record.device_id = device.id
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

    respond_to do |format|
      if @legacy_os_record.update(legacy_os_record_params.except(:tdx_ticket, :device_attributes))
        format.turbo_stream { redirect_to legacy_os_record_path(@legacy_os_record), notice: 'Legacy OS record was successfully updated.' + @note }
      else
        format.turbo_stream
      end
    end
  end


  def archive
    @legacy_os_record = LegacyOsRecord.find(params[:id])
    authorize @legacy_os_record
    respond_to do |format|
      if @legacy_os_record.archive
        format.turbo_stream { redirect_to legacy_os_records_path, notice: 'Legacy OS record was successfully archived.' }
      else
        format.turbo_stream { redirect_to legacy_os_records_path, alert: 'Error archiving Legacy OS record.' }
      end
    end
  end
  
  def audit_log
    authorize @legacy_os_record
    add_breadcrumb(@legacy_os_record.display_name, 
      legacy_os_record_path(@legacy_os_record)
                  )
    add_breadcrumb('Audit')

    if session[:items].present?
      @pagy, @legacy_os_audit_log = pagy(@legacy_os_record.audits.all.reorder(created_at: :desc), items: session[:items])
    else
      @pagy, @legacy_os_audit_log = pagy(@legacy_os_record.audits.all.reorder(created_at: :desc))
    end

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
      
    def add_index_breadcrumb
      add_breadcrumb("Legacy OS Records", legacy_os_records_path)
    end

    def set_form_infotext
      @legacy_os_record_form_text = Infotext.find_by(location: "legacy_os_record_form")
    end

    def set_number_of_items
      if params[:items].present?
        session[:items] = params[:items]
      end
    end

    def legacy_os_record_params
      params.require(:legacy_os_record).permit( :owner_username, :owner_full_name, 
                                                :dept, :phone, 
                                                :additional_dept_contact, 
                                                :additional_dept_contact_phone, 
                                                :support_poc, :legacy_os, 
                                                :unique_app, :unique_hardware, 
                                                :unique_date, :remediation, 
                                                :exception_approval_date, 
                                                :review_date, :review_contact, 
                                                :justification, 
                                                :local_it_support_group, :notes, 
                                                :data_type_id, :device_id, 
                                                :incomplete, :m, attachments: [], 
                                                device_attributes: [:serial, :hostname],
                                                tdx_ticket: [:ticket_link]
                                              )
    end

end
