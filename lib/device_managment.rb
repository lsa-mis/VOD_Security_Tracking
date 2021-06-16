class DeviceManagment

  def if_exist(serial, hostname)
    result = {'success' => false, 'device_id' => nil, 'message' => ''}
    if serial.present?
      if Device.find_by(serial: serial).present?
        device_id = Device.find_by(serial: serial).id
        result['success'] = true
        result['device_id'] = Device.find_by(serial: serial).id
        result['message'] = "The device with serial number [#{serial}] already exists."
      end
    else
      if hostname.present?
        if Device.find_by(hostname: hostname).present?
          result['success'] = true
        result['device_id'] = Device.find_by(hostname: hostname).id
        result['message'] = "The device with hostname [#{hostname}] already exists."
        end
      end
    end
    return result
  end

  def search_tdx(serial, hostname)
    if serial.present? 
      search_field = serial
    else 
      search_field = hostname
    end
    result = {'to_save' => false, 'tdx' => {'in_tdx' => false, 'too_many' => false, 'not_in_tdx' => false}, 'data' => {}, 'message' => ''}
    get_access_token
    if @access_token
      # auth_token exists - call TDX
      get_device_tdx_info(search_field, @access_token)    
      if @device_tdx_info['result']['success']
        result['to_save'] = true
        result['tdx']['in_tdx'] = true
        result['data'] = @device_tdx_info['data']
      elsif @device_tdx_info['result']['more-then_one_result'].present?
        result['to_save'] = false
        result['tdx']['too_many'] = true
        result['message'] = @device_tdx_info['result']['more-then_one_result']
      elsif @device_tdx_info['result']['device_not_in_tdx']
        result['to_save'] = true
        result['tdx']['not_in_tdx'] = true
        result['message'] = @device_tdx_info['result']['device_not_in_tdx']
      end
    else
      # no token - create a device without calling TDX
      result['to_save'] = true
      result['message'] = "No access to TDX API."
    end
    return result
  end

  def save_return_device(data)
    result = {'success' => false, 'device' => nil, 'message' => ''}
    if data.empty?
      result['message'] = 'No data to save a device record'
    else
      device = Device.new(data)
      if device.save
        result['success'] = true
        result['device'] = device
      else
        result['message'] = 'Error saving device'
      end
    end
    return result
  end

  def update_device(device, data)
    result = {'success' => false, 'device' => nil, 'message' => ''}
    if device.update(data)
      result['success'] = true
      result['message'] = 'Device was successfully updated.'
    else
      result['message'] = 'Error saving device'
    end
    # not sure if need this
    result['device'] = device
    return result
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
