class LegacyOsRecordsController < InheritedResources::Base
  devise_group :logged_in, contains: [:user, :admin_user]
  before_action :authenticate_logged_in!
  before_action :set_legacy_os_record, only: [:show, :edit, :update, :archive, :audit_log]
  before_action :add_index_breadcrumb, only: [:index, :show, :new, :edit, :audit_log]
  before_action :set_membership

  def index
    @legacy_os_records = LegacyOsRecord.active
    authorize @legacy_os_records
  end

  def show
    add_breadcrumb(@legacy_os_record.id)
    authorize @legacy_os_record
  end

  def new
    @legacy_os_record = LegacyOsRecord.new
    @device = Device.new
    authorize @legacy_os_record
  end

  def create
    note = ''
    @legacy_os_record = LegacyOsRecord.new(legacy_os_record_params.except(:device_attributes, :tdx_ticket))
    if legacy_os_record_params[:tdx_ticket][:ticket_link].present?
      @legacy_os_record.tdx_tickets.new(ticket_link: legacy_os_record_params[:tdx_ticket][:ticket_link])
    end
    serial = legacy_os_record_params[:device_attributes][:serial]
    hostname = legacy_os_record_params[:device_attributes][:hostname]

    device_class = DeviceManagment.new
    # check the devices table first
    device_exist = device_class.if_exist(serial, hostname)
    if device_exist['success']
      # device exists in devices table
      @legacy_os_record.device_id = device_exist['device_id']
    else
      # create new device (or not)
      search = device_class.search_tdx(serial, hostname)
      if search['to_save']
        if search['tdx']['in_tdx']
          save_device = device_class.save_return_device(search['data'])
        else
          # save with device_params
          save_device = device_class.save_return_device(legacy_os_record_params[:device_attributes])
          note = search['message']
        end
      else
        # more them one search result
        flash.now[:alert] = search['message']
        render turbo_stream: turbo_stream.update("flash", partial: "layouts/notification")
        return
      end
      if save_device['success']
        @legacy_os_record.device_id = save_device['device'].id
      end
    end
    respond_to do |format|
      if @legacy_os_record.save 
        format.turbo_stream { redirect_to legacy_os_record_path(@legacy_os_record), 
        notice: 'Legacy OS record was successfully created. ' + note
      }
      else
        format.turbo_stream
      end
    end
  end

  def edit
    authorize @legacy_os_record
  end

  def update
    if legacy_os_record_params[:tdx_ticket][:ticket_link].present?
      @legacy_os_record.tdx_tickets.create(ticket_link: legacy_os_record_params[:tdx_ticket][:ticket_link])
    end
    # update or create a new device
    serial = legacy_os_record_params[:device_attributes][:serial]
    hostname = legacy_os_record_params[:device_attributes][:hostname]
    device_class = DeviceManagment.new
    device_exist = device_class.if_exist(serial, hostname)
    if device_exist['success']
      @legacy_os_record.device_id = device_exist['device_id']
    else
      # create new device (or not)
      search = device_class.search_tdx(serial, hostname)
      if search['to_save']
        if search['tdx']['in_tdx']
          save_device = device_class.save_return_device(search['data'])
        else
          # save with device_params
          save_device = device_class.save_return_device(legacy_os_record_params[:device_attributes])
          note = search['message']
        end
      else
        # more them one search result
        flash.now[:alert] = search['message']
        render turbo_stream: turbo_stream.update("flash", partial: "layouts/notification")
        return
      end
      if save_device['success']
        @legacy_os_record.device_id = save_device['device'].id
      end
    end
    #  update legacy_os_record
    respond_to do |format|
      if @legacy_os_record.update(legacy_os_record_params.except(:device_attributes, :tdx_ticket))
        format.turbo_stream { redirect_to legacy_os_record_path(@legacy_os_record), notice: 'Legacy OS record was successfully updated.' }
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
    add_breadcrumb(@legacy_os_record.id, 
      legacy_os_record_path(@legacy_os_record)
                  )
    add_breadcrumb('Audit')

    @legacy_os_item_audit_log = @legacy_os_record.audits.all.reorder(created_at: :desc)
  end

  private

    def set_membership
      current_user.membership = session[:user_memberships]
      # logger.debug "************ in legacy_os_record current_user.membership ***** #{current_user.membership}"
    end

    def set_legacy_os_record
      @legacy_os_record = LegacyOsRecord.find(params[:id])
    end
      
    def add_index_breadcrumb
      add_breadcrumb(controller_name.titleize, legacy_os_records_path)
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
                                                :incomplete, attachments: [], 
                                                device_attributes: [:serial, :hostname],
                                                tdx_ticket: [:ticket_link]
                                              )
    end

end
