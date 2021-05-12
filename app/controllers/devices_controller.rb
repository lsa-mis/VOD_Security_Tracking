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
      auth_token = AuthTokenApi.new
      access_token = auth_token.get_auth_token
      if access_token
        # auth_token exists - call TDX
        @device_tdx = DeviceTdxApi.new(search_field, access_token)
        @device_tdx_info = @device_tdx.get_device_data
      else
        # no token - create a device without calling TDX
        @device_tdx_info = {'result' => {'device_not_in_tdx' => "No access to TDX API" }}
      end
    end
    if device_exist.blank?
      # create device
      if @device_tdx_info['result']['more-then_one_result'].present?
        # api returns more then one result or no auth token
        @device = Device.new(device_params)
        respond_to do |format|
          flash.now[:alert] = @device_tdx_info['result']['more-then_one_result'] 
          format.html { render :new }
          format.json { render json: @device.errors, status: :unprocessable_entity }
        end
      elsif @device_tdx_info['result']['success']
        # create device with tdx data
        @device = Device.new(@device_tdx_info['data'])
        respond_to do |format|
          if @device.save
            format.html { redirect_to @device, notice: "device was successfully created. " }
            format.json { render :show, status: :created, location: @device }
          else
            format.html { render :new, status: :unprocessable_entity }
            format.json { render json: @device.errors, status: :unprocessable_entity }
          end
        end
      elsif @device_tdx_info['result']['device_not_in_tdx'].present?
        # device doesn't exist in TDX database (or no access to TDX), create device with device_params
        device_not_in_tdx = @device_tdx_info['result']['device_not_in_tdx']
        @device = Device.new(device_params)
        respond_to do |format|
          if @device.save
            format.html { redirect_to @device, notice: "device was successfully created. " + device_not_in_tdx }
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

  def update
    @device = Device.find(params[:id])
    if @device.serial.present? 
      search_field = @device.serial
    else 
      search_field = @device.hostname
    end
    auth_token = AuthTokenApi.new
    access_token = auth_token.get_auth_token
    if access_token
      # auth_token exists - call TDX
      @device_tdx = DeviceTdxApi.new(search_field, access_token)
      @device_tdx_info = @device_tdx.get_device_data
      respond_to do |format|
        if @device.update(@device_tdx_info['data'])
          format.html { redirect_to @device, notice: "device was successfully updated. "}
          format.json { render :show, status: :created, location: @device }
        else
          format.html { render :new, status: :unprocessable_entity }
          format.json { render json: @device.errors, status: :unprocessable_entity }
        end
      end
    else
      # flash.now[:alert] = "No access to TDX API"
      respond_to do |format|
        format.html { redirect_to devices_url, notice: 'No access to TDX API.' }
        format.json { head :no_content }
      end
    end

  end
  private

    def device_params
      params.require(:device).permit(:serial, :hostname, :mac, :building, :room, :manufacturer, :model, :owner, :department).each { |key, value| value.strip! }
    end

end
