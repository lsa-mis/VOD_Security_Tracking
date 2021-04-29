# == Schema Information
#
# Table name: devices
#
#  id           :bigint           not null, primary key
#  serial       :string(255)
#  hostname     :string(255)
#  mac          :string(255)
#  building     :string(255)
#  room         :string(255)
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  owner        :string(255)
#  department   :string(255)
#  manufacturer :string(255)
#  model        :string(255)
#
class Device < ApplicationRecord
  # before_save :tdx_api
    has_many :sensitive_data_systems
    has_many :legacy_os_records
    audited

    def display_name
      "#{self.serial} - #{self.hostname}" # or whatever column you want
    end

    # def tdx_api

    #   #  get auth token
    #   url = URI("https://apigw.it.umich.edu/um/it/oauth2/token")
  
    #   http = Net::HTTP.new(url.host, url.port)
    #   http.use_ssl = true
    #   http.verify_mode = OpenSSL::SSL::VERIFY_NONE
  
    #   request = Net::HTTP::Post.new(url)
    #   request["content-type"] = 'application/x-www-form-urlencoded'
    #   request["accept"] = 'application/json'
    #   request.body = "grant_type=client_credentials&client_id=#{Rails.application.credentials.um_api[:tdx_client_id]}&client_secret=#{Rails.application.credentials.um_api[:tdx_client_secret]}&scope=tdxticket"
  
    #   response = http.request(request)
    #   access_token = JSON.parse(response.read_body)['access_token']
  
    #   # @device = Device.new(device_params)
    #   # serial = params[:device][:serial]
    #   serial = self.serial
  
    #   url = URI("https://apigw.it.umich.edu/um/it/48/assets/search")
  
    #   http = Net::HTTP.new(url.host, url.port)
    #   http.use_ssl = true
    #   http.verify_mode = OpenSSL::SSL::VERIFY_NONE
  
    #   request = Net::HTTP::Post.new(url)
    #   request["x-ibm-client-id"] = "#{Rails.application.credentials.um_api[:tdx_client_id]}"
    #   request["authorization"] = "Bearer #{access_token}"
    #   request["content-type"] = 'application/json'
    #   request["accept"] = 'application/json'
    #   request.body = "{\"SerialLike\":\"#{serial}\"}"
  
    #   response = http.request(request)
    #   asset_info = JSON.parse(response.read_body)
  
    #   # check if response is not empty
    #   if asset_info.present?
    #     asset_id = asset_info[0]['ID']
  
    #     url = URI("https://apigw.it.umich.edu/um/it/48/assets/#{asset_id}")
  
    #     request = Net::HTTP::Get.new(url)
    #     request["x-ibm-client-id"] = "#{Rails.application.credentials.um_api[:tdx_client_id]}"
    #     request["authorization"] = "Bearer #{access_token}"
    #     request["accept"] = 'application/json'
  
    #     response = http.request(request)
    #     asset_info = JSON.parse(response.read_body)
  
    #     self.building = asset_info['LocationName']
    #     self.room = asset_info['LocationRoomName']
    #     self.hostname = asset_info['Name']
    #     self.owner = asset_info['OwningCustomerName']
    #     self.department = asset_info['OwningDepartmentName']
    #     self.manufacturer = asset_info['ManufacturerName']
    #     self.model = asset_info['ProductModelName']
  
    #     asset_info['Attributes'].each do |att|
    #       if att['Name'] == "MAC Address(es)"
    #         self.mac = att['Value']
    #       end
    #     end
    #   else
    #     redirect_to devices_path, alert: "#{serial} is not in the assets database. Please add this computer to the inventory first." and return
    #   end
    #   self.save
    #   # respond_to do |format|
    #   #   if self.save
    #   #     format.html { redirect_to self, notice: "device was successfully created." }
    #   #     format.json { render :show, status: :created, location: self }
    #   #   else
    #   #     format.html { render :new, status: :unprocessable_entity }
    #   #     format.json { render json: self.errors, status: :unprocessable_entity }
    #   #   end
    #   # end
    # end
end
