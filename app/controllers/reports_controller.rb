class ReportsController < ApplicationController

  def index
    authorize :report, :show?

  end

  def systems_with_review_date_this_month
    sql = "SELECT dpa.id AS ' ', (SELECT dpa_exception_statuses.name FROM dpa_exception_statuses WHERE dpa.dpa_exception_status_id = dpa_exception_statuses.id) AS dpa_exception_status,
          DATE_FORMAT(review_date_exception_first_approval_date, '%m/%d/%Y') AS review_date_exception_first_approval_date, third_party_product_service,
          (SELECT departments.name FROM departments WHERE dpa.department_id = departments.id) AS department_used_by, 
          (SELECT data_types.name FROM data_types WHERE dpa.data_type_id = data_types.id) AS data_type, 
          DATE_FORMAT(exception_approval_date_exception_renewal_date_due, '%m/%d/%Y') AS last_reviewed_date, DATE_FORMAT(review_date_exception_review_date, '%m/%d/%Y') AS next_review_due_date
          FROM dpa_exceptions AS dpa 
          WHERE MONTH(review_date_exception_first_approval_date) = MONTH(CURRENT_DATE())
          AND YEAR(review_date_exception_first_approval_date) = YEAR(CURRENT_DATE()) 
          AND dpa.deleted_at IS NULL"
    records_array = ActiveRecord::Base.connection.exec_query(sql)
    @result = []
    @result.push({"table" => "dpa_exceptions", "total" => records_array.count, "header" => records_array.columns, "rows" => records_array.rows})

    sql = "SELECT isi.id AS ' ', title, DATE_FORMAT(date, '%m/%d/%Y') AS date, people_involved,
          (SELECT data_types.name FROM data_types WHERE isi.data_type_id = data_types.id) AS data_type,
          (SELECT it_security_incident_statuses.name FROM it_security_incident_statuses WHERE isi.it_security_incident_status_id = it_security_incident_statuses.id) AS it_security_incident_status
          FROM it_security_incidents AS isi
          WHERE MONTH(date) = MONTH(CURRENT_DATE())
          AND YEAR(date) = YEAR(CURRENT_DATE()) 
          AND isi.deleted_at IS NULL"
    records_array = ActiveRecord::Base.connection.exec_query(sql)
    @result.push({"table" => "it_security_incidents", "total" => records_array.count, "header" => records_array.columns, "rows" => records_array.rows, "total" => records_array.count})


    sql = "SELECT lor.id AS ' ', owner_full_name, 
          (SELECT CONCAT(serial, ' - ', hostname) FROM devices WHERE lor.device_id = devices.id) AS device,
          legacy_os, DATE_FORMAT(lor.updated_at, '%m/%d/%Y') AS last_modified,
          (SELECT data_types.name FROM data_types WHERE lor.data_type_id = data_types.id) AS data_type, DATE_FORMAT(review_date, '%m/%d/%Y') AS review_date
          FROM legacy_os_records AS lor 
          WHERE MONTH(review_date) = MONTH(CURRENT_DATE())
          AND YEAR(review_date) = YEAR(CURRENT_DATE()) 
          AND lor.deleted_at IS NULL"
    records_array = ActiveRecord::Base.connection.exec_query(sql)
    @result.push({"table" => "legacy_os_records", "total" => records_array.count, "header" => records_array.columns, "rows" => records_array.rows, "total" => records_array.count})      

    sql = "SELECT sds.id AS ' ', owner_full_name,
          (SELECT departments.name FROM departments WHERE sds.department_id = departments.id) AS department,
          (SELECT storage_locations.name FROM storage_locations WHERE sds.storage_location_id = storage_locations.id) AS storage_location,
          IF(device_id IS NULL, '', (SELECT CONCAT(serial, ' - ', hostname) FROM devices WHERE sds.device_id = devices.id)) AS device,
          DATE_FORMAT(sds.updated_at, '%m/%d/%Y') AS last_modified,
          (SELECT data_types.name FROM data_types WHERE sds.data_type_id = data_types.id) AS data_type
          FROM sensitive_data_systems AS sds 
          WHERE MONTH(review_date) = MONTH(CURRENT_DATE()) 
          AND YEAR(review_date) = YEAR(CURRENT_DATE()) 
          AND sds.deleted_at IS NULL"
    records_array = ActiveRecord::Base.connection.exec_query(sql)
    @result.push({"table" => "sensitive_data_systems", "total" => records_array.count, "header" => records_array.columns, "rows" => records_array.rows, "total" => records_array.count})

    if params[:format] == "csv"
      title = "Systems with review date equals " + Date.today.strftime("%B") + " " + Date.today.strftime("%Y")
      data = data_to_csv(@result, title)
      respond_to do |format|
        format.html
        format.csv { send_data data, filename: "systems_with_selected_data_type-#{Date.today}.csv"}
      end
    else
      render turbo_stream: turbo_stream.replace(
        :reportListing,
        partial: "reports/listing")
    end

  end

  def systems_with_selected_data_type

    sql = "SELECT dpa.id AS ' ', (SELECT dpa_exception_statuses.name FROM dpa_exception_statuses WHERE dpa.dpa_exception_status_id = dpa_exception_statuses.id) AS dpa_exception_status,
          DATE_FORMAT(review_date_exception_first_approval_date, '%m/%d/%Y') AS review_date_exception_first_approval_date, third_party_product_service, 
          (SELECT departments.name FROM departments WHERE dpa.department_id = departments.id) AS department_used_by,
          (SELECT data_types.name FROM data_types WHERE dpa.data_type_id = data_types.id) AS data_type,
          DATE_FORMAT(exception_approval_date_exception_renewal_date_due, '%m/%d/%Y') AS last_reviewed_date, DATE_FORMAT(review_date_exception_review_date, '%m/%d/%Y') AS next_review_due_date
          FROM dpa_exceptions AS dpa 
          WHERE dpa.deleted_at IS NULL AND dpa.data_type_id = " + params[:data_type_id]
    records_array = ActiveRecord::Base.connection.exec_query(sql)
    @result = []
    @result.push({"table" => "dpa_exceptions", "total" => records_array.count, "header" => records_array.columns, "rows" => records_array.rows, "total" => records_array.count})
    
    sql = "SELECT isi.id AS ' ', title, date, people_involved,
          (SELECT data_types.name FROM data_types WHERE isi.data_type_id = data_types.id) AS data_type,
          (SELECT it_security_incident_statuses.name FROM it_security_incident_statuses WHERE isi.it_security_incident_status_id = it_security_incident_statuses.id) AS it_security_incident_status
          FROM it_security_incidents AS isi 
          WHERE isi.deleted_at IS NULL AND isi.data_type_id = " + params[:data_type_id]
    records_array = ActiveRecord::Base.connection.exec_query(sql)
    @result.push({"table" => "it_security_incidents", "total" => records_array.count, "header" => records_array.columns, "rows" => records_array.rows, "total" => records_array.count})
    
    sql = "SELECT lor.id AS ' ', owner_full_name, 
          (SELECT CONCAT(serial, ' - ', hostname) FROM devices WHERE lor.device_id = devices.id) AS device,
          legacy_os, DATE_FORMAT(lor.updated_at, '%m/%d/%Y') AS last_modified,
          (SELECT data_types.name FROM data_types WHERE lor.data_type_id = data_types.id) AS data_type, review_date
          FROM legacy_os_records AS lor 
          WHERE lor.deleted_at IS NULL AND lor.data_type_id = " + params[:data_type_id]
    records_array = ActiveRecord::Base.connection.exec_query(sql)
    @result.push({"table" => "legacy_os_records", "total" => records_array.count, "header" => records_array.columns, "rows" => records_array.rows, "total" => records_array.count})
    
    sql = "SELECT sds.id AS ' ', owner_full_name,
          (SELECT departments.name FROM departments WHERE sds.department_id = departments.id) AS department,
          (SELECT storage_locations.name FROM storage_locations WHERE sds.storage_location_id = storage_locations.id) AS storage_location,
          IF(device_id IS NULL, '', (SELECT CONCAT(serial, ' - ', hostname) FROM devices WHERE sds.device_id = devices.id)) AS device,
          DATE_FORMAT(sds.updated_at, '%m/%d/%Y') AS last_modified,
          (SELECT data_types.name FROM data_types WHERE sds.data_type_id = data_types.id) AS data_type
          FROM sensitive_data_systems AS sds
          WHERE sds.deleted_at IS NULL AND sds.data_type_id = " + params[:data_type_id]
    records_array = ActiveRecord::Base.connection.exec_query(sql)
    @result.push({"table" => "sensitive_data_systems", "total" => records_array.count, "header" => records_array.columns, "rows" => records_array.rows, "total" => records_array.count})

    if params[:format] == 'csv'
      data_type = DataType.find(params[:data_type_id]).name
      title = "Systems with " + data_type + " data type"
      data = data_to_csv(@result, title)
      respond_to do |format|
        format.html
        format.csv { send_data data, filename: "systems_with_selected_data_type-#{Date.today}.csv"}
      end
    else
      render turbo_stream: turbo_stream.replace(
            :reportListing,
            partial: "reports/listing")
    end

  end

  def systems_with_selected_data_classification_level

    sql = "SELECT dpa.id AS ' ', 
          (SELECT dpa_exception_statuses.name FROM dpa_exception_statuses WHERE dpa.dpa_exception_status_id = dpa_exception_statuses.id) AS dpa_exception_status,
          DATE_FORMAT(review_date_exception_first_approval_date, '%m/%d/%Y') AS review_date_exception_first_approval_date, third_party_product_service,
          (SELECT departments.name FROM departments WHERE dpa.department_id = departments.id) AS department_used_by, 
          dt.name AS data_type, DATE_FORMAT(exception_approval_date_exception_renewal_date_due, '%m/%d/%Y') AS last_reviewed_date, DATE_FORMAT(review_date_exception_review_date, '%m/%d/%Y') AS next_review_due_date
          FROM dpa_exceptions AS dpa
          JOIN data_types AS dt ON dpa.data_type_id = dt.id 
          JOIN data_classification_levels AS dcl ON dt.data_classification_level_id = dcl.id 
          WHERE dpa.deleted_at IS NULL AND dcl.id = " + params[:data_classification_level_id]
    records_array = ActiveRecord::Base.connection.exec_query(sql)
    @result = []
    @result.push({"table" => "dpa_exceptions", "total" => records_array.count, "header" => records_array.columns, "rows" => records_array.rows})
    
    sql = "SELECT isi.id AS ' ', title, DATE_FORMAT(date, '%m/%d/%Y') AS date, people_involved, dt.name AS data_type,
          (SELECT it_security_incident_statuses.name FROM it_security_incident_statuses WHERE isi.it_security_incident_status_id = it_security_incident_statuses.id) AS it_security_incident_status
          FROM it_security_incidents AS isi
          JOIN data_types AS dt ON isi.data_type_id = dt.id 
          JOIN data_classification_levels AS dcl ON dt.data_classification_level_id = dcl.id
          WHERE isi.deleted_at IS NULL AND dcl.id = " + params[:data_classification_level_id]
    records_array = ActiveRecord::Base.connection.exec_query(sql)
    @result.push({"table" => "it_security_incidents", "total" => records_array.count, "header" => records_array.columns, "rows" => records_array.rows})
    
    sql = "SELECT lor.id AS ' ', owner_full_name, 
          (SELECT CONCAT(serial, ' - ', hostname) FROM devices WHERE lor.device_id = devices.id) AS device,
          legacy_os, DATE_FORMAT(lor.updated_at, '%m/%d/%Y') AS last_modified, dt.name AS data_type, review_date
          FROM legacy_os_records AS lor  
          JOIN data_types AS dt ON lor.data_type_id = dt.id 
          JOIN data_classification_levels AS dcl ON dt.data_classification_level_id = dcl.id
          WHERE lor.deleted_at IS NULL AND dcl.id = " + params[:data_classification_level_id]
    records_array = ActiveRecord::Base.connection.exec_query(sql)
    @result.push({"table" => "legacy_os_records", "total" => records_array.count, "header" => records_array.columns, "rows" => records_array.rows})
    
    sql = "SELECT sds.id AS ' ', owner_full_name,
          (SELECT departments.name FROM departments WHERE sds.department_id = departments.id) AS department,
          (SELECT storage_locations.name FROM storage_locations WHERE sds.storage_location_id = storage_locations.id) AS storage_location,
          IF(device_id IS NULL, '', (SELECT CONCAT(serial, ' - ', hostname) FROM devices WHERE sds.device_id = devices.id)) AS device,
          DATE_FORMAT(sds.updated_at, '%m/%d/%Y') AS last_modified, dt.name AS data_type
          FROM sensitive_data_systems AS sds 
          JOIN data_types AS dt ON sds.data_type_id = dt.id 
          JOIN data_classification_levels AS dcl ON dt.data_classification_level_id = dcl.id
          WHERE sds.deleted_at IS NULL AND dcl.id = " + params[:data_classification_level_id]
    records_array = ActiveRecord::Base.connection.exec_query(sql)
    @result.push({"table" => "sensitive_data_systems", "total" => records_array.count, "header" => records_array.columns, "rows" => records_array.rows})

    if params[:format] == 'csv'
      data_classification_level = DataClassificationLevel.find(params[:data_classification_level_id]).name
      title = "Systems with " + data_classification_level + " data classification level"
      data = data_to_csv(@result)
      respond_to do |format|
        format.html
        format.csv { send_data data, filename: "systems_with_selected_data_classification_level-#{Date.today}.csv"}
      end
    else
      render turbo_stream: turbo_stream.replace(
        :reportListing,
        partial: "reports/listing")
    end

  end

  private

    def data_to_csv(result, title)
      CSV.generate(headers: false) do |csv|
        csv << Array(title)
        result.each do |res|
          line =[]
          line << res['table'].titleize.upcase
          line << "Total number of records: " + res['total'].to_s
          csv << line
          header = res['header'].map! { |e| e.titleize.upcase }
          csv << header
          res['rows'].each do |h|
            h[0] = "http://localhost:3000/" + res['table'] + "/" + h[0].to_s
            csv << h
          end
          csv << Array('')
        end
      end
    end


    def permitted_params
      params.permit(:data_type_id, data_classification_level_id, :format)
      # params.permit! # allow all parameters
    end

end
