module DeviceTdxApi

    def get_device_data
        #  get auth token
        url = URI("https://apigw.it.umich.edu/um/it/oauth2/token")

        http = Net::HTTP.new(url.host, url.port)
        http.use_ssl = true
        http.verify_mode = OpenSSL::SSL::VERIFY_NONE

        request = Net::HTTP::Post.new(url)
        request["content-type"] = 'application/x-www-form-urlencoded'
        request["accept"] = 'application/json'
        request.body = "grant_type=client_credentials&client_id=#{Rails.application.credentials.um_api[:tdx_client_id]}&client_secret=#{Rails.application.credentials.um_api[:tdx_client_secret]}&scope=tdxticket"

        response = http.request(request)
        access_token = JSON.parse(response.read_body)['access_token']

        # get device data from API
        url = URI("https://apigw.it.umich.edu/um/it/48/assets/search")

        http = Net::HTTP.new(url.host, url.port)
        http.use_ssl = true
        http.verify_mode = OpenSSL::SSL::VERIFY_NONE

        request = Net::HTTP::Post.new(url)
        request["x-ibm-client-id"] = "#{Rails.application.credentials.um_api[:tdx_client_id]}"
        request["authorization"] = "Bearer #{access_token}"
        request["content-type"] = 'application/json'
        request["accept"] = 'application/json'
        request.body = "{\"SerialLike\":\"#{@search_field}\"}"

        response = http.request(request)
        asset_info = JSON.parse(response.read_body)
        # check if response is not empty and returns only one result

        if asset_info.present? && asset_info.count == 1
            # serial or hostname 
            @device.serial = asset_info[0]['SerialNumber']
            @device.hostname = asset_info[0]['Name']

            @device.building = asset_info[0]['LocationName']
            @device.room = asset_info[0]['LocationRoomName']
            @device.owner = asset_info[0]['OwningCustomerName']
            @device.department = asset_info[0]['OwningDepartmentName']
            @device.manufacturer = asset_info[0]['ManufacturerName']
            @device.model = asset_info[0]['ProductModelName']
            asset_id = asset_info[0]['ID']

            # get attributes by asset_id
            url = URI("https://apigw.it.umich.edu/um/it/48/assets/#{asset_id}")

            request = Net::HTTP::Get.new(url)
            request["x-ibm-client-id"] = "#{Rails.application.credentials.um_api[:tdx_client_id]}"
            request["authorization"] = "Bearer #{access_token}"
            request["accept"] = 'application/json'

            response = http.request(request)
            asset_info = JSON.parse(response.read_body)

            if asset_info.count == 1 
                asset_info['Attributes'].each do |att|
                    if att['Name'] == "MAC Address(es)"
                        @device.mac = att['Value']
                    end
                end
            end
        elsif asset_info.present? && asset_info.count > 1
            @error_device = "More then one result returned for serial [#{@serial}] or hostname [#{@hostname}]"
        else 
            @device_note = "This device is not present in the TDX Assets database"
        end
      # end of AP
    end
end