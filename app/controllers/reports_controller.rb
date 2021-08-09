class ReportsController < ApplicationController
  before_action :verify_duo_authentication
  devise_group :logged_in, contains: [:user]
  before_action :authenticate_logged_in!

  def index
    authorize :report, :show?
    @report_text = Infotext.find_by(location: "reports")

  end

  def run_report
    @table = params[:table]
    @review_month = params[:review_month]
    @start_date = params[:report_data][:start_date]
    if params[:report_data][:end_date] == ""
      @end_date = Date.today.strftime("%Y-%m-%d")
    else
      @end_date = params[:report_data][:end_date]
    end
    logger.debug "********* start_date #{@start_date}"
    logger.debug "********* end_date #{@end_date}"
    @data_classification_level_id = params[:data_classification_level_id]
    @data_type_id = params[:data_type_id]
    
    create_report

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

    def create_report

      #  review_month filter
      case @review_month
      when "previous"
        and_dpa_review_month = " AND IF(MONTH(CURRENT_DATE()) = 1, (MONTH(review_date_exception_review_date) = 12 AND YEAR(review_date_exception_review_date) = YEAR(CURRENT_DATE()) -1),
                    (MONTH(review_date_exception_review_date) = MONTH(CURRENT_DATE())-1) AND YEAR(review_date_exception_review_date) = YEAR(CURRENT_DATE()))"
        and_review_month = " AND IF(MONTH(CURRENT_DATE()) = 1, (MONTH(review_date) = 12 AND YEAR(review_date) = YEAR(CURRENT_DATE()) -1),
                (MONTH(review_date) = MONTH(CURRENT_DATE())-1) AND YEAR(review_date) = YEAR(CURRENT_DATE()))"
        title_review_month = " a review date equal to " + @review_month + " month & "

      when "current"
        and_dpa_review_month = " AND MONTH(review_date_exception_review_date) = MONTH(CURRENT_DATE()) 
                    AND YEAR(review_date_exception_review_date) = YEAR(CURRENT_DATE())"
        and_review_month = " AND MONTH(review_date) = MONTH(CURRENT_DATE())
                AND YEAR(review_date) = YEAR(CURRENT_DATE())"
        title_review_month = " a review date equal to " + @review_month + " month & "

      when "next"
        and_dpa_review_month = " AND IF(MONTH(CURRENT_DATE()) = 12, (MONTH(review_date_exception_review_date) = 1 AND YEAR(review_date_exception_review_date) = YEAR(CURRENT_DATE()) +1),
                  (MONTH(review_date_exception_review_date) = MONTH(CURRENT_DATE())+1) AND YEAR(review_date_exception_review_date) = YEAR(CURRENT_DATE()))"
        and_review_month = " AND IF(MONTH(CURRENT_DATE()) = 12, (MONTH(review_date) = 1 AND YEAR(review_date) = YEAR(CURRENT_DATE()) +1),
                (MONTH(review_date) = MONTH(CURRENT_DATE())+1) AND YEAR(review_date) = YEAR(CURRENT_DATE()))"
                
      title_review_month = " a review date equal to " + @review_month + " month & "

      else
        and_dpa_review_month = ""
        and_review_month = ""
        title_review_month = ""
      end

      # data_classification_level filter
      if @data_classification_level_id == ""
        and_data_classification_level = ""
        title_data_classification_level = ""
      else
        and_data_classification_level = " AND dcl.id = " + @data_classification_level_id
        title_data_classification_level = DataClassificationLevel.find(@data_classification_level_id).name + " data classification level"
      end

      # create queries 

      # dpa_exceptions
      # created_at range filter
      if @start_date == ""
        and_created_at = " AND dpa.created_at <= '" + @end_date + "'"
        title_created_at = " created before " + @end_date
      else
        and_created_at = " AND dpa.created_at BETWEEN '" + @start_date + "' AND '" + @end_date + "'"
        title_created_at = " & created between " + @start_date + " and " + @end_date
      end

      # data_type filter
      if @data_type_id == ""
        and_data_type = ""
        title_data_type = ""
      else
        and_data_type = " AND dpa.data_type_id = " + @data_type_id 
        title_data_type = " & " + DataType.find(@data_type_id).name + " data type"
      end

      logger.debug " *******************and_dpa_review_month #{and_dpa_review_month}"
      logger.debug " *******************and_data_type #{and_data_type}"
      logger.debug " *******************and_data_classification_level #{and_data_classification_level}"
      logger.debug " *******************and_created_at #{and_created_at}"

      sql_dpa = "SELECT dpa.id AS ' ', 
              (SELECT dpa_exception_statuses.name FROM dpa_exception_statuses WHERE dpa.dpa_exception_status_id = dpa_exception_statuses.id) AS dpa_exception_status,
              DATE_FORMAT(review_date_exception_first_approval_date, '%m/%d/%Y') AS review_date_exception_first_approval_date, third_party_product_service,
              (SELECT departments.name FROM departments WHERE dpa.department_id = departments.id) AS department_used_by, 
              dt.name AS data_type, DATE_FORMAT(exception_approval_date_exception_renewal_date_due, '%m/%d/%Y') AS last_reviewed_date, DATE_FORMAT(review_date_exception_review_date, '%m/%d/%Y') AS next_review_due_date
              FROM dpa_exceptions AS dpa
              JOIN data_types AS dt ON dpa.data_type_id = dt.id 
              JOIN data_classification_levels AS dcl ON dt.data_classification_level_id = dcl.id 
              WHERE dpa.deleted_at IS NULL " + and_dpa_review_month + and_data_type + and_data_classification_level + and_created_at +
              " ORDER BY dpa.created_at desc"
    
      # it_security_incidents
      # created_at range filter
      if @start_date == ""
        and_created_at = " AND isi.created_at <= '" + @end_date + "'"
        title_created_at = " created before " + @end_date
      else
        and_created_at = " AND isi.created_at BETWEEN '" + @start_date + "' AND '" + @end_date + "'"
        title_created_at = " created between " + @start_date + " and " + @end_date
      end

      # data_type filter
      if @data_type_id == ""
        and_data_type = ""
        title_data_type = ""
      else
        and_data_type = " AND isi.data_type_id = " + @data_type_id 
        title_data_type = " and " + DataType.find(@data_type_id).name + " data type"
      end
      sql_isi = "SELECT isi.id AS ' ', title, DATE_FORMAT(date, '%m/%d/%Y') AS date, people_involved, dt.name AS data_type,
      (SELECT it_security_incident_statuses.name FROM it_security_incident_statuses WHERE isi.it_security_incident_status_id = it_security_incident_statuses.id) AS it_security_incident_status
      FROM it_security_incidents AS isi
      JOIN data_types AS dt ON isi.data_type_id = dt.id 
      JOIN data_classification_levels AS dcl ON dt.data_classification_level_id = dcl.id
      WHERE isi.deleted_at IS NULL " + and_review_month + and_data_type + and_data_classification_level + and_created_at +
      " ORDER BY isi.created_at desc"

      # legacy_os_records
      # created_at range filter
      if @start_date == ""
        and_created_at = " AND lor.created_at <= '" + @end_date + "'"
        title_created_at = " created before " + @end_date
      else
        and_created_at = " AND lor.created_at BETWEEN '" + @start_date + "' AND '" + @end_date + "'"
        title_created_at = " created between " + @start_date + " and " + @end_date
      end

      # data_type filter
      if @data_type_id == ""
        and_data_type = ""
        title_data_type = ""
      else
        and_data_type = " AND lor.data_type_id = " + @data_type_id 
        title_data_type = " and " + DataType.find(@data_type_id).name + " data type"
      end
      sql_lor = "SELECT lor.id AS ' ', owner_full_name, 
            (SELECT CONCAT(serial, ' - ', hostname) FROM devices WHERE lor.device_id = devices.id) AS device,
            legacy_os, DATE_FORMAT(lor.updated_at, '%m/%d/%Y') AS last_modified, dt.name AS data_type, review_date
            FROM legacy_os_records AS lor  
            JOIN data_types AS dt ON lor.data_type_id = dt.id 
            JOIN data_classification_levels AS dcl ON dt.data_classification_level_id = dcl.id
            WHERE lor.deleted_at IS NULL " + and_review_month + and_data_type + and_data_classification_level + and_created_at +
            " ORDER BY lor.created_at desc"

      # sensitive_data_systems
      # created_at range filter
      if @start_date == ""
        and_created_at = " AND sds.created_at <= '" + @end_date + "'"
        title_created_at = " created before " + @end_date
      else
        and_created_at = " AND sds.created_at BETWEEN '" + @start_date + "' AND '" + @end_date + "'"
        title_created_at = " created between " + @start_date + " and " + @end_date
      end

      # data_type filter
      if @data_type_id == ""
        and_data_type = ""
        title_data_type = ""
      else
        and_data_type = " AND sds.data_type_id = " + @data_type_id 
        title_data_type = " and " + DataType.find(@data_type_id).name + " data type"
      end
      sql_sds = "SELECT sds.id AS ' ', owner_full_name,
            (SELECT departments.name FROM departments WHERE sds.department_id = departments.id) AS department,
            (SELECT storage_locations.name FROM storage_locations WHERE sds.storage_location_id = storage_locations.id) AS storage_location,
            IF(device_id IS NULL, '', (SELECT CONCAT(serial, ' - ', hostname) FROM devices WHERE sds.device_id = devices.id)) AS device,
            DATE_FORMAT(sds.updated_at, '%m/%d/%Y') AS last_modified, dt.name AS data_type
            FROM sensitive_data_systems AS sds 
            JOIN data_types AS dt ON sds.data_type_id = dt.id 
            JOIN data_classification_levels AS dcl ON dt.data_classification_level_id = dcl.id
            WHERE sds.deleted_at IS NULL " + and_review_month + and_data_type + and_data_classification_level + and_created_at +
            " ORDER BY sds.created_at desc"

      # and build result
      @title = "Systems with " + title_review_month + title_data_classification_level + title_data_type + title_created_at
      case @table
      when "dpa"
        logger.debug " *******************sql_dpa #{sql_dpa}"
        records_array = ActiveRecord::Base.connection.exec_query(sql_dpa)
        @result = []
        @result.push({"table" => "dpa_exceptions", "total" => records_array.count, "header" => records_array.columns, "rows" => records_array.rows})

      when "isi"
        if @review_month == ""
          logger.debug " *******************sql_isi #{sql_isi}"
          records_array = ActiveRecord::Base.connection.exec_query(sql_isi)
          @result = []
          @result.push({"table" => "it_security_incidents", "total" => records_array.count, "header" => records_array.columns, "rows" => records_array.rows})
        end

      when "lor"
        logger.debug " *******************sql_lor #{sql_lor}"
        records_array = ActiveRecord::Base.connection.exec_query(sql_lor)
        @result = []
        @result.push({"table" => "legacy_os_records", "total" => records_array.count, "header" => records_array.columns, "rows" => records_array.rows})

      when "sds"
        logger.debug " *******************sql_sds #{sql_sds}"
        records_array = ActiveRecord::Base.connection.exec_query(sql_sds)
        @result = []
        @result.push({"table" => "sensitive_data_systems", "total" => records_array.count, "header" => records_array.columns, "rows" => records_array.rows})

      else
        # table = "all"
        @result = []
        logger.debug " *******************sql_dpa #{sql_dpa}"
        records_array = ActiveRecord::Base.connection.exec_query(sql_dpa)
        @result.push({"table" => "dpa_exceptions", "total" => records_array.count, "header" => records_array.columns, "rows" => records_array.rows})
        
        if @review_month == ""
          logger.debug " *******************sql_isi #{sql_isi}"
          records_array = ActiveRecord::Base.connection.exec_query(sql_isi)
          @result.push({"table" => "it_security_incidents", "total" => records_array.count, "header" => records_array.columns, "rows" => records_array.rows})
        end

        logger.debug " *******************sql_lor #{sql_lor}"
        records_array = ActiveRecord::Base.connection.exec_query(sql_lor)
        @result.push({"table" => "legacy_os_records", "total" => records_array.count, "header" => records_array.columns, "rows" => records_array.rows})
        
        logger.debug " *******************sql_sds #{sql_sds}"
        records_array = ActiveRecord::Base.connection.exec_query(sql_sds)
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
