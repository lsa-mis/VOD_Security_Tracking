class LegacyOsRecordsController < InheritedResources::Base
  devise_group :logged_in, contains: [:user, :admin_user]
  before_action :authenticate_logged_in!

  def index
    @legacy_os_records = LegacyOsRecord.active
  end

  def new
    @legacy_os_record = LegacyOsRecord.new
  end

  def create
    @legacy_os_record = LegacyOsRecord.new(legacy_os_record_params)
    serial = legacy_os_record_params[:device_attributes][:serial]
    # check if serial exists in devices table 
    if Device.find_by(serial: serial).present?
      @legacy_os_record.device_id = Device.find_by(serial: serial).id
    else
      dev = @legacy_os_record.build_device(serial: legacy_os_record_params[:device_attributes][:serial])
      # get device data from API
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
      serial = legacy_os_record_params[:device_attributes][:serial]    

      url = URI("https://apigw.it.umich.edu/um/it/48/assets/search")

      http = Net::HTTP.new(url.host, url.port)
      http.use_ssl = true
      http.verify_mode = OpenSSL::SSL::VERIFY_NONE

      request = Net::HTTP::Post.new(url)
      request["x-ibm-client-id"] = "#{Rails.application.credentials.um_api[:tdx_client_id]}"
      request["authorization"] = "Bearer #{access_token}"
      request["content-type"] = 'application/json'
      request["accept"] = 'application/json'
      request.body = "{\"SerialLike\":\"#{serial}\"}"

      response = http.request(request)
      asset_info = JSON.parse(response.read_body)

      # check if response is not empty
      if asset_info.present? && asset_info[0]['SerialNumber'] == serial
        asset_id = asset_info[0]['ID']

        url = URI("https://apigw.it.umich.edu/um/it/48/assets/#{asset_id}")

        request = Net::HTTP::Get.new(url)
        request["x-ibm-client-id"] = "#{Rails.application.credentials.um_api[:tdx_client_id]}"
        request["authorization"] = "Bearer #{access_token}"
        request["accept"] = 'application/json'

        response = http.request(request)
        asset_info = JSON.parse(response.read_body)

        dev.building = asset_info['LocationName']
        dev.room = asset_info['LocationRoomName']
        dev.hostname = asset_info['Name']
        dev.owner = asset_info['OwningCustomerName']
        dev.department = asset_info['OwningDepartmentName']
        dev.manufacturer = asset_info['ManufacturerName']
        dev.model = asset_info['ProductModelName']

        asset_info['Attributes'].each do |att|
          if att['Name'] == "MAC Address(es)"
            dev.mac = att['Value']
          end
        end
      else
        device_note = "This device is not present in the TDX Assets database"
      end
      # end of API
    end
    respond_to do |format|
      device_note = "" if device_note.nil?
      if @legacy_os_record.save        
        format.html { redirect_to legacy_os_record_path(@legacy_os_record), notice: 'legacy os record was successfully created. ' + device_note}
        format.json { render :show, status: :created, location: @legacy_os_record }
      else
        format.html { render :new }
        format.json { render json: @legacy_os_record.errors, status: :unprocessable_entity }
      end
    end
  end

  def archive
    @legacy_os_record = LegacyOsRecord.find(params[:id])
    authorize @legacy_os_record
    if @legacy_os_record.archive
      respond_to do |format|
        format.html { redirect_to legacy_os_records_path, notice: 'legacy os record was successfully archived.' }
        format.json { head :no_content }
      end
    else
      format.html { redirect_to legacy_os_records_path, alert: 'error archiving legacy os record.' }
      format.json { head :no_content }
    end
  end
  
  def audit_log
    @legacy_os_records = LegacyOsRecord.all
  end

  private

    def legacy_os_record_params
      # params.require(:legacy_os_record).permit(:owner_username, :owner_full_name, :dept, :phone, :additional_dept_contact, :additional_dept_contact_phone, :support_poc, :legacy_os, :unique_app, :unique_hardware, :unique_date, :remediation, :exception_approval_date, :review_date, :review_contact, :justification, :local_it_support_group, :notes, :data_type_id, :device_id, attachments: [], device_attributes: [:serial, :hostname, :mac, :building, :room, :manufacturer, :model, :owner, :department])
     params.require(:legacy_os_record).permit(:owner_username, :owner_full_name, :dept, :phone, :additional_dept_contact, :additional_dept_contact_phone, :support_poc, :legacy_os, :unique_app, :unique_hardware, :unique_date, :remediation, :exception_approval_date, :review_date, :review_contact, :justification, :local_it_support_group, :notes, :data_type_id, :device_id, attachments: [], device_attributes: [:serial])

    end

end
