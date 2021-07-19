class DevicesController < InheritedResources::Base
  before_action :verify_duo_authentication
  devise_group :logged_in, contains: [:user, :admin_user]
  before_action :authenticate_logged_in!
  before_action :set_device, only: [:show, :edit, :update]
  before_action :add_index_breadcrumb, only: [:index, :show, :new, :edit]

  def index
    @pagy, @devices = pagy(Device.all)
    authorize @devices
  end

  def show
    add_breadcrumb(@device.display_name)
    @legacy_os_records = LegacyOsRecord.where(device_id: @device)
    @sensitive_data_systems = SensitiveDataSystem.where(device_id: @device)
    authorize @device
  end

  def edit
    add_breadcrumb(@device.display_name, device_path(@device))
    add_breadcrumb('Edit')
    authorize @device
  end

  def new
    @device = Device.new
    add_breadcrumb('New')
  end

  def create
    # serial ||= params[:serial] || device_params[:serial]
    # hostname = params[:hostname] || device_params[:hostname]
    serial = params[:device][:serial]
    hostname = params[:device][:hostname] 
    device_class = DeviceManagment.new(serial, hostname)
    if device_class.create_device
      @note ||= device_class.message || ""
      @device = device_class.device
      respond_to do |format|
        if @device.save
          format.turbo_stream { redirect_to @device,
            notice: 'Device record was successfully created.' + @note
          }
        else
          format.turbo_stream
        end
      end
    else
      @device = device_class.device
      flash.now[:alert] = device_class.message
        render turbo_stream: turbo_stream.update("flash", partial: "layouts/notification")
    end
  end

  def update
    device_class = DeviceManagment.new(@device.serial, @device.hostname)
    if device_class.update_device
      note ||= device_class.message || ""
      if @device.update(device_class.device_attr)
        redirect_to @device, notice: 'Device record was successfully updated.' + note
      else
        format.turbo_stream
      end
    else
      flash.now[:alert] = device_class.message
        render turbo_stream: turbo_stream.update("flash", partial: "layouts/notification")
    end
  end
  
  private

    def set_device
      @device = Device.find(params[:id])
    end

    def add_index_breadcrumb
      add_breadcrumb(controller_name.titleize, devices_path)
    end

    def device_params
      params.require(:device).permit( :serial, :hostname, :mac, :building, 
                                      :room, :manufacturer, :model, :owner, 
                                      :department).each { |key, value| value.strip! }
    end

end
