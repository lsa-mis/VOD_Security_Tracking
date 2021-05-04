class DevicesController < InheritedResources::Base
  devise_group :logged_in, contains: [:user, :admin_user]
  before_action :authenticate_logged_in!

  include DeviceTdxApi

  def new
    @device = Device.new
  end

  def create
    @device = Device.new(device_params)    
    @serial = device_params[:serial]
    @hostname = device_params[:hostname]
    if @serial.present? 
      @search_field = @serial
    else 
      @search_field = @hostname
    end
    if @serial.present? && Device.find_by(serial: @serial).present?
        @device_note = "This device with serial number [#{@serial}] already exist"
    elsif @hostname.present? && Device.find_by(hostname: @hostname).present?
        @device_note = "This device with hostname [#{@hostname}] already exist"
    else
      # call DeviceTdxApi module
      get_device_data
    end

    respond_to do |format|
      @device_note = "" if @device_note.nil?
      @error_device = "" if @error_device.nil?
      if @error_device.blank? && @device_note.blank?
        if @device.save
          format.html { redirect_to @device, notice: "device was successfully created." }
          format.json { render :show, status: :created, location: @device }
        else
          format.html { render :new, status: :unprocessable_entity }
          format.json { render json: @device.errors, status: :unprocessable_entity }
        end
      else
        flash.now[:alert] = @error_device + @device_note 
        format.html { render :new }
        format.json { render json: @device.errors, status: :unprocessable_entity }
      end
    end
  end
  private

    def device_params
      params.require(:device).permit(:serial, :hostname, :mac, :building, :room, :manufacturer, :model, :owner, :department)
    end

end
