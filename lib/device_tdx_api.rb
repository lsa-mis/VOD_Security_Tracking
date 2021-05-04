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
            if @serial && asset_info[0]['SerialNumber'] == @search_field
                dev = @legacy_os_record.build_device(serial: @serial)
                dev.hostname = asset_info[0]['Name']
            elsif @hostname && asset_info[0]['Name'] == @search_field
                dev = @legacy_os_record.build_device(hostname: @hostname)
                dev.serial = asset_info[0]['SerialNumber']
            end
            dev.building = asset_info[0]['LocationName']
            dev.room = asset_info[0]['LocationRoomName']
            dev.owner = asset_info[0]['OwningCustomerName']
            dev.department = asset_info[0]['OwningDepartmentName']
            dev.manufacturer = asset_info[0]['ManufacturerName']
            dev.model = asset_info[0]['ProductModelName']
            asset_id = asset_info[0]['ID']

            # get attributes by asset_id
            url = URI("https://apigw.it.umich.edu/um/it/48/assets/#{asset_id}")

            request = Net::HTTP::Get.new(url)
            request["x-ibm-client-id"] = "#{Rails.application.credentials.um_api[:tdx_client_id]}"
            request["authorization"] = "Bearer #{access_token}"
            request["accept"] = 'application/json'

            response = http.request(request)
            asset_info = JSON.parse(response.read_body)

            # dev.building = asset_info['LocationName']
            # dev.room = asset_info['LocationRoomName']
            # dev.owner = asset_info['OwningCustomerName']
            # dev.department = asset_info['OwningDepartmentName']
            # dev.manufacturer = asset_info['ManufacturerName']
            # dev.model = asset_info['ProductModelName']
            if asset_info.count == 1 
                asset_info['Attributes'].each do |att|
                    if att['Name'] == "MAC Address(es)"
                        dev.mac = att['Value']
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