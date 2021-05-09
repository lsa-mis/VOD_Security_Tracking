class DevicesController < InheritedResources::Base
  devise_group :logged_in, contains: [:user, :admin_user]
  before_action :authenticate_logged_in!

  def new
    @device = Device.new
  end

  def create
    serial = device_params[:serial]
    hostname = device_params[:hostname]
    # check the devices table first
    if serial.present? && Device.find_by(serial: serial).present?
      device_exist =  "The device with serial number [#{serial}] already exist"
    elsif hostname.present? && Device.find_by(hostname: hostname).present?
      device_exist = "The device with hostname [#{hostname}] already exist"
    else
      # device doesn't exist in devices table, have to create search_field and call API
      if serial.present? 
        search_field = serial
      else 
        search_field = hostname
      end
      @device_tdx = DeviceTdxApi.new(search_field)
      @device_tdx_info = @device_tdx.get_device_data
    end
    if device_exist.blank?
      if @device_tdx_info['error_device'].present?
        # api retutns more then one result or no auth token
        @device = Device.new(device_params)
        respond_to do |format|
          flash.now[:alert] = @device_tdx_info['error_device'] 
          format.html { render :new }
          format.json { render json: @device.errors, status: :unprocessable_entity }
        end
      elsif @device_tdx_info['device_tdx'].present?
        # create device with tdx data
        @device_tdx_info.delete("device_tdx")
        @device = Device.new(@device_tdx_info)
        respond_to do |format|
          if @device.save
            format.html { redirect_to @device, notice: "device was successfully created. " }
            format.json { render :show, status: :created, location: @device }
          else
            format.html { render :new, status: :unprocessable_entity }
            format.json { render json: @device.errors, status: :unprocessable_entity }
          end
        end
      elsif @device_tdx_info['device_note'].present?
        # device doesn't exist in TDX database, should be created with device_params
        device_note = @device_tdx_info['device_note']
        @device = Device.new(device_params)
        respond_to do |format|
          if @device.save
            format.html { redirect_to @device, notice: "device was successfully created. " + device_note }
            format.json { render :show, status: :created, location: @device }
          else
            format.html { render :new, status: :unprocessable_entity }
            format.json { render json: @device.errors, status: :unprocessable_entity }
          end
        end
      end
    else
      # devise exists in the database
      @device = Device.new(device_params)
      respond_to do |format|
        flash.now[:alert] = device_exist
        format.html { render :new }
        format.json { render json: @device.errors, status: :unprocessable_entity }
      end
    end
  end
  private

    def device_params
      params.require(:device).permit(:serial, :hostname, :mac, :building, :room, :manufacturer, :model, :owner, :department).each { |key, value| value.strip! }
    end

end
