class DevicesController < InheritedResources::Base
  devise_group :logged_in, contains: [:user, :admin_user]
  before_action :authenticate_logged_in!
  before_action :set_device, only: [:show, :edit, :update]
  before_action :add_index_breadcrumb, only: [:index, :show, :new, :edit]
  before_action :get_access_token, only: [:create, :update]
  before_action :set_membership

  def show
    add_breadcrumb(@device.display_name)
  end

  def edit
    add_breadcrumb(@device.display_name, device_path(@device))
    add_breadcrumb('Edit')
  end

  def new
    @device = Device.new
    add_breadcrumb('New')
  end

  def create
    serial = device_params[:serial]
    hostname = device_params[:hostname]
    # check the devices table first
    if serial.present? && Device.find_by(serial: serial).present?
      device_exist =  "The device with serial number [#{serial}] already exists."
    elsif hostname.present? && Device.find_by(hostname: hostname).present?
      device_exist = "The device with hostname [#{hostname}] already exists."
    else
      # device doesn't exist in devices table, have to create search_field and call API
      if serial.present? 
        search_field = serial
      else 
        search_field = hostname
      end

      if @access_token
        # auth_token exists - call TDX
        @device_tdx_info = get_device_tdx_info(search_field, @access_token)
      else
        # no token - create a device without calling TDX
        @device_tdx_info = {'result' => {'device_not_in_tdx' => "No access to TDX API." }}
      end
    end
    if device_exist.blank?
      # check TDX API result
      if @device_tdx_info['result']['more-then_one_result'].present?
        # api returns more then one result or no auth token
        @device = Device.new(device_params)
        flash.now[:alert] = @device_tdx_info['result']['more-then_one_result'] 
        render turbo_stream: turbo_stream.update("flash", partial: "layouts/notification")
      elsif @device_tdx_info['result']['success']
        # create device with tdx data
        @device = Device.new(@device_tdx_info['data'])
        respond_to do |format|
          if @device.save
            format.html { redirect_to @device, notice: "Device was successfully created. " }
            format.json { render :show, status: :created, location: @device }
          else
            format.html { render :new, status: :unprocessable_entity }
            format.json { render json: @device.errors, status: :unprocessable_entity }
          end
        end
      else @device_tdx_info['result']['device_not_in_tdx'].present?
        # device doesn't exist in TDX database (or no access to TDX), create device with device_params
        device_not_in_tdx = @device_tdx_info['result']['device_not_in_tdx']
        @device = Device.new(device_params)
        respond_to do |format|
          if @device.save
            format.html { redirect_to @device, 
                          notice: "Device was successfully created. " + device_not_in_tdx 
                        }
            format.json { render :show, status: :created, location: @device }
          else
            format.html { render :new, status: :unprocessable_entity }
            format.json { render json: @device.errors, status: :unprocessable_entity }
          end
        end
      end
    else
      # device exists in the database
      @device = Device.new(device_params)
      flash.now[:alert] = device_exist
      render turbo_stream: turbo_stream.update("flash", partial: "layouts/notification")
    end
  end

  def update
    @device = Device.find(params[:id])
    if @device.serial.present? 
      search_field = @device.serial
    else 
      search_field = @device.hostname
    end
    @access_token = get_access_token
    if @access_token
      # auth_token exists - call TDX
      @device_tdx_info = get_device_tdx_info(search_field, @access_token)
      # check TDX API return
      if @device_tdx_info['result']['more-then_one_result'].present?
        respond_to do |format|
          format.html { redirect_to @device, 
                        notice: "#{@device_tdx_info['result']['more-then_one_result']}"
                      }
          format.json { render :show, status: :created, location: @device }
        end
      elsif @device_tdx_info['result']['device_not_in_tdx'].present?
        respond_to do |format|
          format.html { redirect_to @device, 
                        notice: "#{@device_tdx_info['result']['device_not_in_tdx']}"
                      }
          format.json { render :show, status: :created, location: @device }
        end
      else @device_tdx_info['result']['success']
        respond_to do |format|
          if @device.update(@device_tdx_info['data'])
            format.html { redirect_to @device, notice: "Device was successfully updated. "}
            format.json { render :show, status: :created, location: @device }
          else
            format.html { render :new, status: :unprocessable_entity }
            format.json { render json: @device.errors, status: :unprocessable_entity }
          end
        end
      end
    else
      # no auth token
      respond_to do |format|
        format.html { redirect_to devices_url, notice: 'No access to TDX API.' }
        format.json { head :no_content }
      end
    end
  end 
  
  private

    def set_membership
      if user_signed_in?
        current_user.membership = session[:user_memberships]
      else
        redirect_to root_path
      end
    end

    def set_device
      @device = Device.find(params[:id])
    end

    def add_index_breadcrumb
      add_breadcrumb(controller_name.titleize, devices_path)
    end 
    
    def get_access_token
      auth_token = AuthTokenApi.new
      @access_token = auth_token.get_auth_token
    end

    def get_device_tdx_info(search_field, access_token)
      device_tdx = DeviceTdxApi.new(search_field, access_token)
      @device_tdx_info = device_tdx.get_device_data
    end

    def device_params
      params.require(:device).permit( :serial, :hostname, :mac, :building, 
                                      :room, :manufacturer, :model, :owner, 
                                      :department).each { |key, value| value.strip! }
    end

end
