class ReportsController < ApplicationController
  before_action :verify_duo_authentication
  devise_group :logged_in, contains: [:user]
  before_action :authenticate_logged_in!

  def index
    authorize :report, :show?
    @report_text = Infotext.find_by(location: "reports")

  end

  def run_report
    table = params[:table]
    review_month = params[:review_month]
    start_date = params[:report_data][:start_date]
    end_date = params[:report_data][:end_date]
    logger.debug "********* end_date #{end_date}"
    data_classification_level_id = params[:data_classification_level_id]
    data_type_id = params[:data_type_id]
    
    if review_month != ""
      systems_with_review_date(table, review_month)
    elsif data_classification_level_id != "" || data_type_id != ""
      systems_with_selected_data(table, data_classification_level_id, data_type_id, start_date, end_date)


    end

    if params[:format] == "csv"
      data = data_to_csv(@result, @title)
      respond_to do |format|
        format.html
        format.csv { send_data data, filename: "#{@title}-#{Date.today}.csv"}
      end
    else
      render turbo_stream: turbo_stream.replace(
        :reportListing,
        partial: "reports/listing")
    end

  end

  private

    def systems_with_review_date(table = "all", review_month = "current", data_classification_level_id = "", data_type_id = "")
      case review_month
      when "previous"
        where_dpa = "WHERE IF(MONTH(CURRENT_DATE()) = 1, (MONTH(review_date_exception_review_date) = 12 AND YEAR(review_date_exception_review_date) = YEAR(CURRENT_DATE()) -1),
                    (MONTH(review_date_exception_review_date) = MONTH(CURRENT_DATE())-1) AND YEAR(review_date_exception_review_date) = YEAR(CURRENT_DATE()))"
        where = "WHERE IF(MONTH(CURRENT_DATE()) = 1, (MONTH(review_date) = 12 AND YEAR(review_date) = YEAR(CURRENT_DATE()) -1),
                (MONTH(review_date) = MONTH(CURRENT_DATE())-1) AND YEAR(review_date) = YEAR(CURRENT_DATE()))"
      when "current"
        where_dpa = "WHERE MONTH(review_date_exception_review_date) = MONTH(CURRENT_DATE()) 
                    AND YEAR(review_date_exception_review_date) = YEAR(CURRENT_DATE())"
        where = "WHERE MONTH(review_date) = MONTH(CURRENT_DATE())
                AND YEAR(review_date) = YEAR(CURRENT_DATE())"
      when "next"
        where_dpa = "WHERE IF(MONTH(CURRENT_DATE()) = 12, (MONTH(review_date_exception_review_date) = 1 AND YEAR(review_date_exception_review_date) = YEAR(CURRENT_DATE()) +1),
                   (MONTH(review_date_exception_review_date) = MONTH(CURRENT_DATE())+1) AND YEAR(review_date_exception_review_date) = YEAR(CURRENT_DATE()))"
        where = "WHERE IF(MONTH(CURRENT_DATE()) = 12, (MONTH(review_date) = 1 AND YEAR(review_date) = YEAR(CURRENT_DATE()) +1),
                (MONTH(review_date) = MONTH(CURRENT_DATE())+1) AND YEAR(review_date) = YEAR(CURRENT_DATE()))"

      else
        flash.now[:alert] = "Select rewiew month"
        render turbo_stream: turbo_stream.update("flash", partial: "layouts/notification")
        return
      end
      sql = "SELECT dpa.id AS ' ', (SELECT dpa_exception_statuses.name FROM dpa_exception_statuses WHERE dpa.dpa_exception_status_id = dpa_exception_statuses.id) AS dpa_exception_status,
            DATE_FORMAT(review_date_exception_first_approval_date, '%m/%d/%Y') AS review_date_exception_first_approval_date, third_party_product_service,
            (SELECT departments.name FROM departments WHERE dpa.department_id = departments.id) AS department_used_by, 
            (SELECT data_types.name FROM data_types WHERE dpa.data_type_id = data_types.id) AS data_type, 
            DATE_FORMAT(exception_approval_date_exception_renewal_date_due, '%m/%d/%Y') AS last_reviewed_date, DATE_FORMAT(review_date_exception_review_date, '%m/%d/%Y') AS next_review_due_date
            FROM dpa_exceptions AS dpa " +
            where_dpa +
            "AND dpa.deleted_at IS NULL ORDER BY dpa.created_at desc"
      records_array = ActiveRecord::Base.connection.exec_query(sql)
      @result = []
      @result.push({"table" => "dpa_exceptions", "total" => records_array.count, "header" => records_array.columns, "rows" => records_array.rows})

      sql = "SELECT lor.id AS ' ', owner_full_name, 
            (SELECT CONCAT(serial, ' - ', hostname) FROM devices WHERE lor.device_id = devices.id) AS device,
            legacy_os, DATE_FORMAT(lor.updated_at, '%m/%d/%Y') AS last_modified,
            (SELECT data_types.name FROM data_types WHERE lor.data_type_id = data_types.id) AS data_type, DATE_FORMAT(review_date, '%m/%d/%Y') AS review_date
            FROM legacy_os_records AS lor " +
            where +
            "AND lor.deleted_at IS NULL ORDER BY lor.created_at desc"
      records_array = ActiveRecord::Base.connection.exec_query(sql)
      @result.push({"table" => "legacy_os_records", "total" => records_array.count, "header" => records_array.columns, "rows" => records_array.rows})      

      sql = "SELECT sds.id AS ' ', owner_full_name,
            (SELECT departments.name FROM departments WHERE sds.department_id = departments.id) AS department,
            (SELECT storage_locations.name FROM storage_locations WHERE sds.storage_location_id = storage_locations.id) AS storage_location,
            IF(device_id IS NULL, '', (SELECT CONCAT(serial, ' - ', hostname) FROM devices WHERE sds.device_id = devices.id)) AS device,
            DATE_FORMAT(sds.updated_at, '%m/%d/%Y') AS last_modified,
            (SELECT data_types.name FROM data_types WHERE sds.data_type_id = data_types.id) AS data_type
            FROM sensitive_data_systems AS sds " +
            where + 
            "AND sds.deleted_at IS NULL ORDER BY sds.created_at desc"
      records_array = ActiveRecord::Base.connection.exec_query(sql)
      @result.push({"table" => "sensitive_data_systems", "total" => records_array.count, "header" => records_array.columns, "rows" => records_array.rows})

      @title = "Systems with a review date equal to " + review_month + " month"

    end

    def systems_with_selected_data(table = "all", data_classification_level_id = "", data_type_id= "", start_date = "", end_date = "")

      case data_type_id
      when ""
        and_data_type = ""
        data_type = ""
      else
        and_data_type = " AND " + table + ".data_type_id = " + data_type_id 
        data_type = " and " + DataType.find(data_type_id).name + " data type"
      end

      case data_classification_level_id
      when ""
        and_data_classification_level = ""
        data_classification_level = ""
      else
        and_data_classification_level = " AND dcl.id = " + data_classification_level_id
        data_classification_level = DataClassificationLevel.find(data_classification_level_id).name + " data classification level"
      end

      if start_date == ""
        and_created_at = " AND " + table + ".created_at <= '" + end_date + "'"
      else
        and_created_at = " AND " + table + ".created_at BETWEEN '" + start_date + "' AND '" + end_date + "'"
      end

      @title = "Systems with " + data_classification_level + data_type

      case table
      when "dpa"
        sql = "SELECT dpa.id AS ' ', 
              (SELECT dpa_exception_statuses.name FROM dpa_exception_statuses WHERE dpa.dpa_exception_status_id = dpa_exception_statuses.id) AS dpa_exception_status,
              DATE_FORMAT(review_date_exception_first_approval_date, '%m/%d/%Y') AS review_date_exception_first_approval_date, third_party_product_service,
              (SELECT departments.name FROM departments WHERE dpa.department_id = departments.id) AS department_used_by, 
              dt.name AS data_type, DATE_FORMAT(exception_approval_date_exception_renewal_date_due, '%m/%d/%Y') AS last_reviewed_date, DATE_FORMAT(review_date_exception_review_date, '%m/%d/%Y') AS next_review_due_date
              FROM dpa_exceptions AS dpa
              JOIN data_types AS dt ON dpa.data_type_id = dt.id 
              JOIN data_classification_levels AS dcl ON dt.data_classification_level_id = dcl.id 
              WHERE dpa.deleted_at IS NULL " + and_data_type + and_data_classification_level + and_created_at +
              " ORDER BY dpa.created_at desc"
        logger.debug " *******************sql #{sql}"

        records_array = ActiveRecord::Base.connection.exec_query(sql)
        @result = []
        @result.push({"table" => "dpa_exceptions", "total" => records_array.count, "header" => records_array.columns, "rows" => records_array.rows})
        
      when "isi"
        sql = "SELECT isi.id AS ' ', title, DATE_FORMAT(date, '%m/%d/%Y') AS date, people_involved, dt.name AS data_type,
              (SELECT it_security_incident_statuses.name FROM it_security_incident_statuses WHERE isi.it_security_incident_status_id = it_security_incident_statuses.id) AS it_security_incident_status
              FROM it_security_incidents AS isi
              JOIN data_types AS dt ON isi.data_type_id = dt.id 
              JOIN data_classification_levels AS dcl ON dt.data_classification_level_id = dcl.id
              WHERE isi.deleted_at IS NULL " + and_data_type + and_data_classification_level + and_created_at +
              " ORDER BY isi.created_at desc"
        logger.debug " *******************sql #{sql}"

        records_array = ActiveRecord::Base.connection.exec_query(sql)
        @result = []
        @result.push({"table" => "it_security_incidents", "total" => records_array.count, "header" => records_array.columns, "rows" => records_array.rows})
        
      when "lor"
        sql = "SELECT lor.id AS ' ', owner_full_name, 
              (SELECT CONCAT(serial, ' - ', hostname) FROM devices WHERE lor.device_id = devices.id) AS device,
              legacy_os, DATE_FORMAT(lor.updated_at, '%m/%d/%Y') AS last_modified, dt.name AS data_type, review_date
              FROM legacy_os_records AS lor  
              JOIN data_types AS dt ON lor.data_type_id = dt.id 
              JOIN data_classification_levels AS dcl ON dt.data_classification_level_id = dcl.id
              WHERE lor.deleted_at IS NULL " + and_data_type + and_data_classification_level + and_created_at +
              " ORDER BY lor.created_at desc"
        logger.debug " *******************sql #{sql}"

        records_array = ActiveRecord::Base.connection.exec_query(sql)
        @result = []
        @result.push({"table" => "legacy_os_records", "total" => records_array.count, "header" => records_array.columns, "rows" => records_array.rows})
      
      when "sds"
        sql = "SELECT sds.id AS ' ', owner_full_name,
              (SELECT departments.name FROM departments WHERE sds.department_id = departments.id) AS department,
              (SELECT storage_locations.name FROM storage_locations WHERE sds.storage_location_id = storage_locations.id) AS storage_location,
              IF(device_id IS NULL, '', (SELECT CONCAT(serial, ' - ', hostname) FROM devices WHERE sds.device_id = devices.id)) AS device,
              DATE_FORMAT(sds.updated_at, '%m/%d/%Y') AS last_modified, dt.name AS data_type
              FROM sensitive_data_systems AS sds 
              JOIN data_types AS dt ON sds.data_type_id = dt.id 
              JOIN data_classification_levels AS dcl ON dt.data_classification_level_id = dcl.id
              WHERE sds.deleted_at IS NULL " + and_data_type + and_data_classification_level + and_created_at +
              " ORDER BY sds.created_at desc"
        logger.debug " *******************sql #{sql}"

        records_array = ActiveRecord::Base.connection.exec_query(sql)
        @result = []
        @result.push({"table" => "sensitive_data_systems", "total" => records_array.count, "header" => records_array.columns, "rows" => records_array.rows})

      else
        # table = "all"
        if data_type_id == ""
          and_data_type = ""
        end

        if data_type_id != ""
          and_data_type = " AND dpa.data_type_id = " + data_type_id 
        end

        if start_date == ""
          and_created_at = " AND dpa.created_at <= '" + end_date + "'"
        else
          and_created_at = " AND dpa.created_at BETWEEN '" + start_date + "' AND '" + end_date + "'"
        end

        sql = "SELECT dpa.id AS ' ', 
              (SELECT dpa_exception_statuses.name FROM dpa_exception_statuses WHERE dpa.dpa_exception_status_id = dpa_exception_statuses.id) AS dpa_exception_status,
              DATE_FORMAT(review_date_exception_first_approval_date, '%m/%d/%Y') AS review_date_exception_first_approval_date, third_party_product_service,
              (SELECT departments.name FROM departments WHERE dpa.department_id = departments.id) AS department_used_by, 
              dt.name AS data_type, DATE_FORMAT(exception_approval_date_exception_renewal_date_due, '%m/%d/%Y') AS last_reviewed_date, DATE_FORMAT(review_date_exception_review_date, '%m/%d/%Y') AS next_review_due_date
              FROM dpa_exceptions AS dpa
              JOIN data_types AS dt ON dpa.data_type_id = dt.id 
              JOIN data_classification_levels AS dcl ON dt.data_classification_level_id = dcl.id 
              WHERE dpa.deleted_at IS NULL " + and_data_type + and_data_classification_level + and_created_at +
              " ORDER BY dpa.created_at desc"
        records_array = ActiveRecord::Base.connection.exec_query(sql)
        @result = []
        @result.push({"table" => "dpa_exceptions", "total" => records_array.count, "header" => records_array.columns, "rows" => records_array.rows})
        
        if data_type_id != ""
          and_data_type = " AND isi.data_type_id = " + data_type_id 
        end

        if start_date == ""
          and_created_at = " AND isi.created_at <= '" + end_date + "'"
        else
          and_created_at = " AND isi.created_at BETWEEN '" + start_date + "' AND '" + end_date + "'"
        end

        sql = "SELECT isi.id AS ' ', title, DATE_FORMAT(date, '%m/%d/%Y') AS date, people_involved, dt.name AS data_type,
              (SELECT it_security_incident_statuses.name FROM it_security_incident_statuses WHERE isi.it_security_incident_status_id = it_security_incident_statuses.id) AS it_security_incident_status
              FROM it_security_incidents AS isi
              JOIN data_types AS dt ON isi.data_type_id = dt.id 
              JOIN data_classification_levels AS dcl ON dt.data_classification_level_id = dcl.id
              WHERE isi.deleted_at IS NULL " + and_data_type + and_data_classification_level + and_created_at +
              " ORDER BY isi.created_at desc"
        records_array = ActiveRecord::Base.connection.exec_query(sql)
        @result.push({"table" => "it_security_incidents", "total" => records_array.count, "header" => records_array.columns, "rows" => records_array.rows})
        
        if data_type_id != ""
          and_data_type = " AND lor.data_type_id = " + data_type_id 
        end

        if start_date == ""
          and_created_at = " AND lor.created_at <= '" + end_date + "'"
        else
          and_created_at = " AND lor.created_at BETWEEN '" + start_date + "' AND '" + end_date + "'"
        end

        sql = "SELECT lor.id AS ' ', owner_full_name, 
              (SELECT CONCAT(serial, ' - ', hostname) FROM devices WHERE lor.device_id = devices.id) AS device,
              legacy_os, DATE_FORMAT(lor.updated_at, '%m/%d/%Y') AS last_modified, dt.name AS data_type, review_date
              FROM legacy_os_records AS lor  
              JOIN data_types AS dt ON lor.data_type_id = dt.id 
              JOIN data_classification_levels AS dcl ON dt.data_classification_level_id = dcl.id
              WHERE lor.deleted_at IS NULL " + and_data_type + and_data_classification_level + and_created_at +
              " ORDER BY lor.created_at desc"
        records_array = ActiveRecord::Base.connection.exec_query(sql)
        @result.push({"table" => "legacy_os_records", "total" => records_array.count, "header" => records_array.columns, "rows" => records_array.rows})
      
        if data_type_id != ""
          and_data_type = " AND sds.data_type_id = " + data_type_id 
        end

        if start_date == ""
          and_created_at = " AND sds.created_at <= '" + end_date + "'"
        else
          and_created_at = " AND sds.created_at BETWEEN '" + start_date + "' AND '" + end_date + "'"
        end

        sql = "SELECT sds.id AS ' ', owner_full_name,
              (SELECT departments.name FROM departments WHERE sds.department_id = departments.id) AS department,
              (SELECT storage_locations.name FROM storage_locations WHERE sds.storage_location_id = storage_locations.id) AS storage_location,
              IF(device_id IS NULL, '', (SELECT CONCAT(serial, ' - ', hostname) FROM devices WHERE sds.device_id = devices.id)) AS device,
              DATE_FORMAT(sds.updated_at, '%m/%d/%Y') AS last_modified, dt.name AS data_type
              FROM sensitive_data_systems AS sds 
              JOIN data_types AS dt ON sds.data_type_id = dt.id 
              JOIN data_classification_levels AS dcl ON dt.data_classification_level_id = dcl.id
              WHERE sds.deleted_at IS NULL " + and_data_type + and_data_classification_level + and_created_at +
              " ORDER BY sds.created_at desc"
        records_array = ActiveRecord::Base.connection.exec_query(sql)
        @result.push({"table" => "sensitive_data_systems", "total" => records_array.count, "header" => records_array.columns, "rows" => records_array.rows})

      end

    
    end

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
      params.permit(:data_type_id, data_classification_level_id, :format, 
                  :table, :review_month, :start_date, :end_date)
      # params.permit! # allow all parameters
    end

end
