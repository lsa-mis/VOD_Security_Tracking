class DevicesController < InheritedResources::Base

  require 'uri'
  require 'net/http'
  require 'openssl'
  require 'json'

  def new
    @device = Device.new
  end

  def create

    #  get auth token
    url = URI("https://apigw.it.umich.edu/um/it/oauth2/token")

    http = Net::HTTP.new(url.host, url.port)
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE

    request = Net::HTTP::Post.new(url)
    request["content-type"] = 'application/x-www-form-urlencoded'
    request["accept"] = 'application/json'
    request.body = "grant_type=client_credentials&client_id=b0cbe658-add1-4106-afd7-3c8b008c64bf&client_secret=E1dN3jI1jT0qD0uF4vT6gN1rW8fB4kO8kD8aY6xF2rG3wQ0eN2&scope=tdxticket"

    response = http.request(request)
    access_token = JSON.parse(response.read_body)['access_token']

    @device = Device.new(device_params)
    serial = params[:device][:serial]

    url = URI("https://apigw.it.umich.edu/um/it/48/assets/search")

    http = Net::HTTP.new(url.host, url.port)
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE

    request = Net::HTTP::Post.new(url)
    request["x-ibm-client-id"] = 'b0cbe658-add1-4106-afd7-3c8b008c64bf'
    request["authorization"] = "Bearer #{access_token}"
    request["content-type"] = 'application/json'
    request["accept"] = 'application/json'
    request.body = "{\"SerialLike\":\"#{serial}\"}"

    response = http.request(request)
    asset_info = JSON.parse(response.read_body)
    asset_id = asset_info[0]['ID']

    url = URI("https://apigw.it.umich.edu/um/it/48/assets/#{asset_id}")

    request = Net::HTTP::Get.new(url)
    request["x-ibm-client-id"] = 'b0cbe658-add1-4106-afd7-3c8b008c64bf'
    request["authorization"] = "Bearer #{access_token}"
    request["accept"] = 'application/json'

    response = http.request(request)
    asset_info = JSON.parse(response.read_body)

    @device.building = asset_info['LocationName']
    @device.room = asset_info['LocationRoomName']
    @device.hostname = asset_info['Name']

    asset_info['Attributes'].each do |att|
      if att['Name'] == "MAC Address(es)"
        @device.mac = att['Value']
      end
    end

    respond_to do |format|
      if @device.save
        format.html { redirect_to @device, notice: "device was successfully created." }
        format.json { render :show, status: :created, location: @device }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @device.errors, status: :unprocessable_entity }
      end
    end
  end
  private

    def device_params
      params.require(:device).permit(:serial, :hostname, :mac, :building, :room)
    end

end
