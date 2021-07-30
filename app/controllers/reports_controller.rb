class ReportsController < ApplicationController

  def index

  end

  def legacy_os_records_review_date_next_month
    sql = "Select support_poc, owner_username, legacy_os, hostname
      FROM legacy_os_records AS lor JOIN devices AS dev ON lor.device_id = dev.id
      WHERE IF(MONTH(CURRENT_DATE()) = 12, (MONTH(review_date) = 1 AND YEAR(review_date) = YEAR(CURRENT_DATE()) +1),
      (MONTH(review_date) = MONTH(CURRENT_DATE())+1) AND YEAR(review_date) = YEAR(CURRENT_DATE())) AND lor.deleted_at IS NULL"
    records_array = ActiveRecord::Base.connection.exec_query(sql)
    @result = []
    @result.push({"table" => "legacy_os_records", "header" => records_array.columns, "rows" => records_array.rows, "total" => records_array.count})

    render turbo_stream: turbo_stream.replace(
      :reportListing,
      partial: "reports/listing")

  end

  def sensitive_data_system_review_date_this_month
    sql = "SELECT support_poc, owner_username, 
          IF(device_id IS NULL, '', (SELECT CONCAT(serial, ' - ', hostname) FROM devices WHERE sds.device_id = devices.id)) AS device 
          FROM sensitive_data_systems AS sds WHERE MONTH(review_date) = MONTH(CURRENT_DATE()) AND YEAR(review_date) = YEAR(CURRENT_DATE()) 
          AND sds.deleted_at IS NULL"
    records_array = ActiveRecord::Base.connection.exec_query(sql)
    @result = []
    @result.push({"table" => "sensitive_data_systems", "header" => records_array.columns, "rows" => records_array.rows, "total" => records_array.count})

    render turbo_stream: turbo_stream.replace(
      :reportListing,
      partial: "reports/listing")

  end

  def systems_with_selected_data_type

    sql = "SELECT used_by, third_party_product_service FROM dpa_exceptions WHERE deleted_at IS NULL AND data_type_id = " + params[:data_type_id]
    records_array = ActiveRecord::Base.connection.exec_query(sql)
    @result = []
    @result.push({"table" => "dpa_exceptions", "header" => records_array.columns, "rows" => records_array.rows, "total" => records_array.count})
    
    sql = "SELECT title, people_involved, equipment_involved FROM it_security_incidents WHERE deleted_at IS NULL AND data_type_id = " + params[:data_type_id]
    records_array = ActiveRecord::Base.connection.exec_query(sql)
    @result.push({"table" => "it_security_incidents", "header" => records_array.columns, "rows" => records_array.rows, "total" => records_array.count})
    
    sql = "SELECT owner_username, legacy_os, hostname
    FROM legacy_os_records as lor join devices as dev on lor.device_id = dev.id WHERE lor.deleted_at IS NULL AND data_type_id = " + params[:data_type_id]
    records_array = ActiveRecord::Base.connection.exec_query(sql)
    @result.push({"table" => "legacy_os_records", "header" => records_array.columns, "rows" => records_array.rows, "total" => records_array.count})
    
    sql = "SELECT name, owner_username, (SELECT storage_locations.name FROM storage_locations WHERE sd.storage_location_id = storage_locations.id) AS storage_location, hostname
    FROM sensitive_data_systems AS sd JOIN devices as dev on sd.device_id = dev.id WHERE sd.deleted_at IS NULL AND data_type_id = " + params[:data_type_id]
    records_array = ActiveRecord::Base.connection.exec_query(sql)
    @result.push({"table" => "sensitive_data_systems", "header" => records_array.columns, "rows" => records_array.rows, "total" => records_array.count})

    render turbo_stream: turbo_stream.replace(
      :reportListing,
      partial: "reports/listing")

  end

  def permitted_params
    params.permit(:data_type_id)
    # params.permit! # allow all parameters
  end

end
