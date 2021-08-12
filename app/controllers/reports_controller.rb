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
    if params[:review_month].present?
      @review_month = params[:review_month]
    else 
      @review_month = ""
    end
    @start_date = params[:report_data][:start_date]
    if params[:report_data][:end_date] == ""
      @end_date = Date.today.strftime("%Y-%m-%d")
    else
      @end_date = params[:report_data][:end_date]
    end
    
    @data_classification_level_id = params[:data_classification_level_id]
    @data_type_id = params[:data_type_id]
    
    create_report

    if params[:format] == "csv"
      data = data_to_csv(@result, @title)
      respond_to do |format|
        format.html
        format.csv { send_data data, filename: "VOD-report-#{DateTime.now.strftime('%-d-%-m-%Y at %I-%M%p')}.csv"}
      end
    else
      render turbo_stream: turbo_stream.replace(
        :reportListing,
        partial: "reports/listing")
    end

  end

  private

    def data_classification_level_data_type_filter(data_classification_level, data_type_id, table)

      if @data_classification_level_id == "" && @data_type_id == ""
        @join_tables = ""
        @and_data_classification_level = ""
        @title_data_classification_level = ""
        @and_data_type = ""
        @title_data_type = ""

      elsif @data_classification_level_id != "" && @data_type_id != ""
        @join_tables = " JOIN data_types AS dt ON " + table + ".data_type_id = dt.id 
                      JOIN data_classification_levels AS dcl ON dt.data_classification_level_id = dcl.id "
        @and_data_classification_level = " AND dcl.id = " + @data_classification_level_id
        @title_data_classification_level = DataClassificationLevel.find(@data_classification_level_id).name + " data classification level & "
        @and_data_type = " AND " + table + ".data_type_id = " + @data_type_id 
        @title_data_type = DataType.find(@data_type_id).name + " data type & "

      elsif @data_classification_level_id == "" && @data_type_id != ""
        @join_tables = " JOIN data_types AS dt ON " + table + ".data_type_id = dt.id "
        @and_data_classification_level = ""
        @title_data_classification_level = ""
        @and_data_type = " AND " + table + ".data_type_id = " + @data_type_id 
        @title_data_type = DataType.find(@data_type_id).name + " data type & "

      else
        # @data_classification_level_id != "" && @data_type_id == ""
        @join_tables = " JOIN data_types AS dt ON " + table + ".data_type_id = dt.id 
                      JOIN data_classification_levels AS dcl ON dt.data_classification_level_id = dcl.id "
        @and_data_classification_level = " AND dcl.id = " + @data_classification_level_id
        @title_data_classification_level = DataClassificationLevel.find(@data_classification_level_id).name + " data classification level & "
        @and_data_type = ""
        @title_data_type = ""
      end
    end

    def review_month_filter(review_month)

      case review_month
      when "previous"
        @and_dpa_review_month = " AND MONTH(review_date_exception_review_date) = MONTH(CURRENT_DATE() - INTERVAL 1 MONTH) 
            AND YEAR(review_date_exception_review_date) = YEAR(CURRENT_DATE() - INTERVAL 1 MONTH)"
        @and_review_month = " AND MONTH(review_date) = MONTH(CURRENT_DATE() - INTERVAL 1 MONTH) 
            AND YEAR(review_date) = YEAR(CURRENT_DATE() - INTERVAL 1 MONTH)"
        @title_review_month = "a review date equal to " + review_month + " month & "

      when "current"
        @and_dpa_review_month = " AND MONTH(review_date_exception_review_date) = MONTH(CURRENT_DATE()) 
                    AND YEAR(review_date_exception_review_date) = YEAR(CURRENT_DATE())"
        @and_review_month = " AND MONTH(review_date) = MONTH(CURRENT_DATE())
                AND YEAR(review_date) = YEAR(CURRENT_DATE())"
        @title_review_month = "a review date equal to " + review_month + " month & "

      when "next"
        @and_dpa_review_month = " AND MONTH(review_date_exception_review_date) = MONTH(CURRENT_DATE() + INTERVAL 1 MONTH) 
            AND YEAR(review_date_exception_review_date) = YEAR(CURRENT_DATE() + INTERVAL 1 MONTH)"
        @and_review_month = " AND MONTH(review_date) = MONTH(CURRENT_DATE() + INTERVAL 1 MONTH) 
            AND YEAR(review_date) = YEAR(CURRENT_DATE() + INTERVAL 1 MONTH)"
                
      @title_review_month = "a review date equal to " + review_month + " month & "

      else
        @and_dpa_review_month = ""
        @and_review_month = ""
        @title_review_month = ""
      end
    end

    def created_at_filter(start_date, end_date, table)

      if start_date == ""
        @and_created_at = " AND " + table + ".created_at <= '" + end_date + "'"
        @title_created_at = "created through " + end_date
      else
        @and_created_at = " AND " + table + ".created_at BETWEEN '" + start_date + "' AND '" + end_date + "'"
        @title_created_at = "created between " + start_date + " and " + end_date
      end

    end

    def dpa_query
      @sql_dpa = "SELECT dpa.id AS ' ', 
              (SELECT dpa_exception_statuses.name FROM dpa_exception_statuses WHERE dpa.dpa_exception_status_id = dpa_exception_statuses.id) AS dpa_exception_status,
              DATE_FORMAT(review_date_exception_first_approval_date, '%m/%d/%Y') AS review_date_exception_first_approval_date, third_party_product_service,
              (SELECT departments.name FROM departments WHERE dpa.department_id = departments.id) AS department_used_by, 
              (SELECT data_types.name FROM data_types WHERE dpa.data_type_id = data_types.id) AS data_type, DATE_FORMAT(exception_approval_date_exception_renewal_date_due, '%m/%d/%Y') AS last_reviewed_date, DATE_FORMAT(review_date_exception_review_date, '%m/%d/%Y') AS next_review_due_date
              FROM dpa_exceptions AS dpa " +
              @join_tables +
              "WHERE dpa.deleted_at IS NULL " + @and_dpa_review_month + @and_data_type + @and_data_classification_level + @and_created_at +
              " ORDER BY dpa.created_at desc"
    end

    def isi_query
      @sql_isi = "SELECT isi.id AS ' ', title, DATE_FORMAT(date, '%m/%d/%Y') AS date, people_involved, 
      (SELECT data_types.name FROM data_types WHERE isi.data_type_id = data_types.id) AS data_type,
      (SELECT it_security_incident_statuses.name FROM it_security_incident_statuses WHERE isi.it_security_incident_status_id = it_security_incident_statuses.id) AS it_security_incident_status
      FROM it_security_incidents AS isi " +
      @join_tables +
      "WHERE isi.deleted_at IS NULL " + @and_review_month + @and_data_type + @and_data_classification_level + @and_created_at +
      " ORDER BY isi.created_at desc"
    end

    def lor_query
      @sql_lor = "SELECT lor.id AS ' ', owner_full_name, 
            (SELECT CONCAT(serial, ' - ', hostname) FROM devices WHERE lor.device_id = devices.id) AS device,
            legacy_os, DATE_FORMAT(lor.updated_at, '%m/%d/%Y') AS last_modified,
            (SELECT data_types.name FROM data_types WHERE lor.data_type_id = data_types.id)AS data_type, review_date
            FROM legacy_os_records AS lor " +
            @join_tables +
            "WHERE lor.deleted_at IS NULL " + @and_review_month + @and_data_type + @and_data_classification_level + @and_created_at +
            " ORDER BY lor.created_at desc"
    end

    def sds_query
      @sql_sds = "SELECT sds.id AS ' ', owner_full_name,
            (SELECT departments.name FROM departments WHERE sds.department_id = departments.id) AS department,
            (SELECT storage_locations.name FROM storage_locations WHERE sds.storage_location_id = storage_locations.id) AS storage_location,
            IF(device_id IS NULL, '', (SELECT CONCAT(serial, ' - ', hostname) FROM devices WHERE sds.device_id = devices.id)) AS device,
            DATE_FORMAT(sds.updated_at, '%m/%d/%Y') AS last_modified, 
            (SELECT data_types.name FROM data_types WHERE sds.data_type_id = data_types.id) AS data_type
            FROM sensitive_data_systems AS sds " +
            @join_tables +
            "WHERE sds.deleted_at IS NULL " + @and_review_month + @and_data_type + @and_data_classification_level + @and_created_at +
            " ORDER BY sds.created_at desc"
    end

    def create_report
      review_month_filter(@review_month)

      case @table
      when "dpa"
        data_classification_level_data_type_filter(@data_classification_level, @data_type_id, @table)
        created_at_filter(@start_date, @end_date, @table)
        dpa_query
        records_array = ActiveRecord::Base.connection.exec_query(@sql_dpa)
        @result = []
        @result.push({"table" => "dpa_exceptions", "total" => records_array.count, "header" => records_array.columns, "rows" => records_array.rows})

      when "isi"
        data_classification_level_data_type_filter(@data_classification_level, @data_type_id, @table)
        created_at_filter(@start_date, @end_date, @table)
        isi_query
        if @review_month == ""
          records_array = ActiveRecord::Base.connection.exec_query(@sql_isi)
          @result = []
          @result.push({"table" => "it_security_incidents", "total" => records_array.count, "header" => records_array.columns, "rows" => records_array.rows})
        end

      when "lor"
        data_classification_level_data_type_filter(@data_classification_level, @data_type_id, @table)
        created_at_filter(@start_date, @end_date, @table)
        lor_query
        records_array = ActiveRecord::Base.connection.exec_query(@sql_lor)
        @result = []
        @result.push({"table" => "legacy_os_records", "total" => records_array.count, "header" => records_array.columns, "rows" => records_array.rows})

      when "sds"
        data_classification_level_data_type_filter(@data_classification_level, @data_type_id, @table)
        created_at_filter(@start_date, @end_date, @table)
        sds_query
        records_array = ActiveRecord::Base.connection.exec_query(@sql_sds)
        @result = []
        @result.push({"table" => "sensitive_data_systems", "total" => records_array.count, "header" => records_array.columns, "rows" => records_array.rows})

      else
        # table = "all"
        @result = []
        data_classification_level_data_type_filter(@data_classification_level, @data_type_id, "dpa")
        created_at_filter(@start_date, @end_date, "dpa")
        dpa_query
        records_array = ActiveRecord::Base.connection.exec_query(@sql_dpa)
        @result.push({"table" => "dpa_exceptions", "total" => records_array.count, "header" => records_array.columns, "rows" => records_array.rows})
        
        if @review_month == ""
          data_classification_level_data_type_filter(@data_classification_level, @data_type_id, "isi")
          created_at_filter(@start_date, @end_date, "isi")
          isi_query
          records_array = ActiveRecord::Base.connection.exec_query(@sql_isi)
          @result.push({"table" => "it_security_incidents", "total" => records_array.count, "header" => records_array.columns, "rows" => records_array.rows})
        end
        
        data_classification_level_data_type_filter(@data_classification_level, @data_type_id, "lor")
        created_at_filter(@start_date, @end_date, "lor")
        lor_query
        records_array = ActiveRecord::Base.connection.exec_query(@sql_lor)
        @result.push({"table" => "legacy_os_records", "total" => records_array.count, "header" => records_array.columns, "rows" => records_array.rows})
        
        data_classification_level_data_type_filter(@data_classification_level, @data_type_id, "sds")
        created_at_filter(@start_date, @end_date, "sds")
        sds_query
        records_array = ActiveRecord::Base.connection.exec_query(@sql_sds)
        @result.push({"table" => "sensitive_data_systems", "total" => records_array.count, "header" => records_array.columns, "rows" => records_array.rows})
      end
      @title = "Systems with " + @title_review_month + @title_data_classification_level + @title_data_type + @title_created_at

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
