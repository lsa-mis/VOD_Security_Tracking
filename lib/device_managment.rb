class DeviceManagment
  attr_accessor :result, :save_with_tdx, :too_many, :not_in_tdx, :message, :data,
                :device, :serial, :hostname, :device_attr, :exist

  def initialize (s, h)
    self.serial = s
    self.hostname = h
  end

  def create_device
    if device_exist?
      message = self.message
      exist = true
      return 
    else
      search = search_tdx(self.serial, self.hostname)
      if search
        if self.save_with_tdx
          self.device = Device.new(self.data)
          return true
        elsif self.too_many
          $too_many = true
          return false
        elsif self.not_in_tdx
          self.device = Device.new
          self.device.serial = self.serial
          self.device.hostname = self.hostname
          return true
        end
      else
        self.message = "Error searching for device"
        return false
      end
    end
  end

  def update_device
    search = search_tdx(self.serial, self.hostname)
    if search
      if self.save_with_tdx
        self.device_attr = self.data
        return true
      elsif self.too_many
        return false
      elsif self.not_in_tdx
        self.device_attr = {"serial" => "#{self.serial}", "hostname" => "#{self.hostname}" } 
        return true
      end
    else
      self.message = "Error searching for device"
      return false
    end
  end

  def device_exist?
    if self.serial.present?
      if Device.find_by(serial: self.serial).present?
        self.device = Device.find_by(serial: self.serial)
        self.message = "The device with serial number [#{self.serial}] already exists."
        return true
      end
    else
      if self.hostname.present?
        if Device.find_by(hostname: self.hostname).present?
          self.device = Device.find_by(hostname: self.hostname)
          self.message = "The device with hostname [#{self.hostname}] already exists."
          return true
        end
      end
    end
    return false
  end

  private

  def search_tdx(serial, hostname)
    result = false
    if serial.present? 
      search_field = serial
    else 
      search_field = hostname
    end
    get_access_token
    if @access_token
      # auth_token exists - call TDX
      get_device_tdx_info(search_field, @access_token)    
      if @device_tdx_info['result']['success']
        self.save_with_tdx = true
        self.data = @device_tdx_info['data']
        result = true
        return result
      elsif @device_tdx_info['result']['more-then_one_result'].present?
        self.too_many = true
        self.message = @device_tdx_info['result']['more-then_one_result']
        result = true
        return result
      elsif @device_tdx_info['result']['device_not_in_tdx']
        self.not_in_tdx = true
        self.message = @device_tdx_info['result']['device_not_in_tdx']
        result = true
        return result
      end
    else
      # no token - create a device without calling TDX
      self.not_in_tdx = true
      self.message = "No access to TDX API."
      result = true
      return result
    end
  end

  def get_access_token
    auth_token = AuthTokenApi.new
    @access_token = auth_token.get_auth_token
  end

  def get_device_tdx_info(search_field, access_token)
    device_tdx = DeviceTdxApi.new(search_field, access_token)
    @device_tdx_info = device_tdx.get_device_data
  end

end
