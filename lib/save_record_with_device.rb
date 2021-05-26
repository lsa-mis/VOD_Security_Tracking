module SaveRecordWithDevice
    protected

    def save_with_device(record, device_tdx_info, path)

        if device_tdx_info['result']['more-then_one_result'].present?
            # api returns more then one result or no auth token
            flash.now[:alert] = device_tdx_info['result']['more-then_one_result']
            render turbo_stream: turbo_stream.update("flash", partial: "partials/flash")
        elsif device_tdx_info['result']['success']
            # create device with tdx data
            record.build_device(device_tdx_info['data'])
            respond_to do |format|
                if record.save 
                    if (path == "sensitive_data_system")
                        format.html { redirect_to sensitive_data_system_path(record), notice: 'Record was successfully created. '}
                    else
                        format.html { redirect_to legacy_os_record_path(record), notice: 'Record was successfully created. '}
                    end
                    format.json { render :show, status: :created, location: record }
                else
                    format.html { render :new }
                    format.json { render json: record.errors, status: :unprocessable_entity }
                end
            end
        elsif device_tdx_info['result']['device_not_in_tdx'].present?
            # device doesn't exist in TDX database, should be created with device_params
            if (path == "sensitive_data_system")
                record.build_device(sensitive_data_system_params[:device_attributes])
            else
                record.build_device(legacy_os_record_params[:device_attributes])
            end
            respond_to do |format|
                if record.save 
                    if (path == "sensitive_data_system")
                        format.html { redirect_to sensitive_data_system_path(record), notice: 'Record was successfully created. ' + "#{device_tdx_info['result']['device_not_in_tdx']}"}
                    else
                        format.html { redirect_to legacy_os_record_path(record), notice: 'Record was successfully created. '}
                    end
                    format.json { render :show, status: :created, location: record }
                else
                    format.html { render :new }
                    format.json { render json: record.errors, status: :unprocessable_entity }
                end
            end
        end
    end

end