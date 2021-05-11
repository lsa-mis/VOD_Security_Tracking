class DeviceTdxApi 

    def initialize(search_field)
        @search_field = search_field
        @device_tdx = {}
        Rails.logger.info "[#{self.class}] - initialize"
    end

    def get_auth_token
        begin
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
            @access_token = JSON.parse(response.read_body)['access_token']
        rescue => @error
           puts @error.inspect
        end
    end

    def get_device_data
        if get_auth_token
            # get device data from API
            url = URI("https://apigw.it.umich.edu/um/it/48/assets/search")

            http = Net::HTTP.new(url.host, url.port)
            http.use_ssl = true
            http.verify_mode = OpenSSL::SSL::VERIFY_NONE

            request = Net::HTTP::Post.new(url)
            request["x-ibm-client-id"] = "#{Rails.application.credentials.um_api[:tdx_client_id]}"
            request["authorization"] = "Bearer #{@access_token}"
            request["content-type"] = 'application/json'
            request["accept"] = 'application/json'
            request.body = "{\"SerialLike\":\"#{@search_field}\"}"

            response = http.request(request)
            asset_info = JSON.parse(response.read_body)
            # check if response is not empty and returns only one result
            Rails.logger.info "[#{self.class}] - **********************asset_info.count #{asset_info.count}"

            if asset_info.present? && asset_info.count == 1
                @device_tdx['device_tdx'] = 'yes'
                # serial or hostname 
                @device_tdx['serial'] = asset_info[0]['SerialNumber']
                @device_tdx['hostname'] = asset_info[0]['Name']

                @device_tdx['building'] = asset_info[0]['LocationName']
                @device_tdx['room'] = asset_info[0]['LocationRoomName']
                @device_tdx['owner'] = asset_info[0]['OwningCustomerName']
                @device_tdx['department'] = asset_info[0]['OwningDepartmentName']
                @device_tdx['manufacturer'] = asset_info[0]['ManufacturerName']
                @device_tdx['model'] = asset_info[0]['ProductModelName']
                asset_id = asset_info[0]['ID']

                # get attributes by asset_id
                url = URI("https://apigw.it.umich.edu/um/it/48/assets/#{asset_id}")

                request = Net::HTTP::Get.new(url)
                request["x-ibm-client-id"] = "#{Rails.application.credentials.um_api[:tdx_client_id]}"
                request["authorization"] = "Bearer #{@access_token}"
                request["accept"] = 'application/json'

                response = http.request(request)
                asset_info = JSON.parse(response.read_body)

                if asset_info.present? 
                    asset_info['Attributes'].each do |att|
                        if att['Name'] == "MAC Address(es)"
                            @device_tdx['mac'] = att['Value']
                        end
                    end
                end
            elsif asset_info.present? && asset_info.count > 1
                Rails.logger.debug "[#{self.class}] - ***************************************@search_field: #{@search_field}"
                @device_tdx['error_device'] = "More then one result returned for serial or hostname [#{@search_field}]"
            else 
                @device_tdx['device_note'] = "This device is not present in the TDX Assets database"
            end
        else
            @device_tdx['error_device'] =  "No authentication token" + @error.inspect
        end
        @device_tdx
    end
end