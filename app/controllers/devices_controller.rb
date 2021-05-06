class DevicesController < InheritedResources::Base
  devise_group :logged_in, contains: [:user, :admin_user]
  before_action :authenticate_logged_in!

  def new
    @device = Device.new
  end

  def create
    serial = device_params[:serial]
    hostname = device_params[:hostname]

    # if serial.present? && Device.find_by(serial: serial).present?
    #   flash.now[:alert] =  "This device with serial number [#{serial}] already exist"

    # elsif hostname.present? && Device.find_by(hostname: hostname).present?
    #   flash.now[:alert] = "This device with hostname [#{hostname}] already exist"
    # else
    
      if serial.present? 
        search_field = serial
      else 
        search_field = hostname
      end

      @device_tdx = DeviceTdxApi.new(search_field)
      @device_tdx_info = @device_tdx.get_device_data

      if @device_tdx_info['error_device'] 
        flash.now[:alert] = @device_tdx_info['error_device']
        # format.html { render :new }
        # format.json { render json: @device.errors, status: :unprocessable_entity }
      else
        if @device_tdx_info['device_note']
          @device = Device.new(device_params)
        else
          @device = Device.new(@device_tdx_info)
        end
        respond_to do |format|
          device_note = @device_tdx_info['device_note'] || ""
          if @device.save
            format.html { redirect_to @device, notice: "device was successfully created. " + device_note }
            format.json { render :show, status: :created, location: @device }
          else
            format.html { render :new, status: :unprocessable_entity }
            format.json { render json: @device.errors, status: :unprocessable_entity }
          end
        end
      end
    # end
  end
  private

    def device_params
      params.require(:device).permit(:serial, :hostname, :mac, :building, :room)
    end

end
