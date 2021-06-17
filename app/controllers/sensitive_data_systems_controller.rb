class SensitiveDataSystemsController < InheritedResources::Base
  devise_group :logged_in, contains: [:user, :admin_user]
  before_action :authenticate_logged_in!
  before_action :set_sensitive_data_system, only: [:show, :edit, :update, :archive, :audit_log]
  before_action :add_index_breadcrumb, only: [:index, :show, :new, :edit, :audit_log]
  before_action :set_membership

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
    @sensitive_data_system = SensitiveDataSystem.new(sensitive_data_system_params.except(:device_attributes, :tdx_ticket))
    if sensitive_data_system_params[:tdx_ticket][:ticket_link].present?
      @sensitive_data_system.tdx_tickets.new(ticket_link: sensitive_data_system_params[:tdx_ticket][:ticket_link])
    end
    note = ''
    serial = sensitive_data_system_params[:device_attributes][:serial]
    hostname = sensitive_data_system_params[:device_attributes][:hostname]
    if serial.present? || hostname.present?
      device_class = DeviceManagment.new
      # check the devices table first
      device_exist = device_class.if_exist(serial, hostname)
      if device_exist['success']
        @sensitive_data_system.device_id = device_exist['device_id']
      else
        # create new device (or not)
        search = device_class.search_tdx(serial, hostname)
        if search['success']
          if search['save_with_tdx']
            save_device = device_class.save_return_device(search['data'])
          elsif search['not_in_tdx']
            # save with device_params
            save_device = device_class.save_return_device(sensitive_data_system_params[:device_attributes])
            note = search['message']
          elsif search['too_many']
            # more them one search result
            flash.now[:alert] = search['message']
            render turbo_stream: turbo_stream.update("flash", partial: "layouts/notification")
            return
          end
        else
          flash.now[:alert] = "Error searching for device"
            render turbo_stream: turbo_stream.update("flash", partial: "layouts/notification")
            return
        end
        if save_device['success']
          @sensitive_data_system.device_id = save_device['device'].id
        end
      end
    end
    respond_to do |format|
      if @sensitive_data_system.save 
        format.turbo_stream { redirect_to sensitive_data_system_path(@sensitive_data_system), notice: 'Sensitive Data System record was successfully created. ' + note }
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
    # create a device and get device_id
    if StorageLocation.find(sensitive_data_system_params[:storage_location_id]).device_is_required
      serial = sensitive_data_system_params[:device_attributes][:serial]
      hostname = sensitive_data_system_params[:device_attributes][:hostname]
      if serial.present? || hostname.present?
        device_class = DeviceManagment.new
        # check the devices table first
        device_exist = device_class.if_exist(serial, hostname)
        if device_exist['success']
          @sensitive_data_system.device_id = device_exist['device_id']
        else
          # create new device (or not)
          search = device_class.search_tdx(serial, hostname)
          if search['success']
            if search['save_with_tdx']
              save_device = device_class.save_return_device(search['data'])
            elsif search['not_in_tdx']
              # save with device_params
              save_device = device_class.save_return_device(sensitive_data_system_params[:device_attributes])
              note = search['message']
            elsif search['too_many']
              # more them one search result
              flash.now[:alert] = search['message']
              render turbo_stream: turbo_stream.update("flash", partial: "layouts/notification")
              return
            end
          else
            flash.now[:alert] = "Error searching for device"
            render turbo_stream: turbo_stream.update("flash", partial: "layouts/notification")
            return
          end
          if save_device['success']
            @sensitive_data_system.device_id = save_device['device'].id
          end
        end
      end
    else 
      @sensitive_data_system.device_id = nil
    end

    respond_to do |format|
      if @sensitive_data_system.update(sensitive_data_system_params.except(:device_attributes, :tdx_ticket))
        # Rails.logger.info(@sensitive_data_system.errors.inspect) 
        format.turbo_stream { redirect_to sensitive_data_system_path(@sensitive_data_system), notice: 'Sensitive Data System record was successfully updated.' }
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

    def set_membership
      current_user.membership = session[:user_memberships]
    end

    def set_sensitive_data_system
      @sensitive_data_system = SensitiveDataSystem.find(params[:id])
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
                                                    :device_id,
                                                    :incomplete, 
                                                    attachments: [], 
                                                    device_attributes: [:serial, :hostname], 
                                                    tdx_ticket: [:ticket_link]
                                                  )
    end

end
