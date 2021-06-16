class DevicesController < InheritedResources::Base
  devise_group :logged_in, contains: [:user, :admin_user]
  before_action :authenticate_logged_in!
  before_action :set_device, only: [:show, :update]
  before_action :add_index_breadcrumb, only: [:index, :show, :new]

  def show
    add_breadcrumb(@device.display_name)
  end

  # def edit
  #   add_breadcrumb(@device.display_name, device_path(@device))
  #   add_breadcrumb('Edit')
  # end

  def new
    @device = Device.new
    add_breadcrumb('New')
  end

  def create
    note = ''
    serial = device_params[:serial]
    hostname = device_params[:hostname]

    device_class = DeviceManagment.new
    # check the devices table first
    device_exist = device_class.if_exist(serial, hostname)
    if device_exist['success']
      # devise exists in devices table
      @device = Device.new(device_params)
      flash.now[:alert] = device_exist['message']
      render turbo_stream: turbo_stream.update("flash", partial: "layouts/notification")
    else
      # device doesn't exist in devices table; create a new device (or not)
      search = device_class.search_tdx(serial, hostname)
      if search['to_save']
        if search['tdx']['in_tdx']
          save_device = device_class.save_return_device(search['data'])
        else
          # save with device_params
          save_device = device_class.save_return_device(device_params)
          note = search['message']
        end
      else
        # more them one search result
        flash.now[:alert] = search['message']
        render turbo_stream: turbo_stream.update("flash", partial: "layouts/notification")
        return
      end
      if save_device['success']
        @device = save_device['device']
        respond_to do |format|
          format.turbo_stream { redirect_to @device, notice: "Device was successfully created. " + note }
        end
      else
        flash.now[:alert] = save_device['message']
        render turbo_stream: turbo_stream.update("flash", partial: "layouts/notification")
      end
    end
  end

  def update
    device_class = DeviceManagment.new
    logger.debug "********************** @device.serial #{@device.serial}"
    search = device_class.search_tdx(@device.serial, @device.hostname)
    if search['to_save']
      # have returned data from TDX
      if search['tdx']['in_tdx']
        update_device = device_class.update_device(@device, search['data'])
        # not reloading the page - how to?
        flash.now[:alert] = update_device['message']
        render turbo_stream: turbo_stream.update("flash", partial: "layouts/notification")

        # and this not working  
        # @device = update_device['device']
        # respond_to do |format|
        #   format.turbo_stream { redirect_to @device, notice: "#{update_device['message']}" }
        # end
      else
        # device still not in tdx or no access to tdx -> no need to update
        flash.now[:alert] = search['message']
        render turbo_stream: turbo_stream.update("flash", partial: "layouts/notification")
      end
    else
      # too many results
      flash.now[:alert] = search['message']
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
