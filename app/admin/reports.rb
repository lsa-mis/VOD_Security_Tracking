ActiveAdmin.register_page "Reports" do
  menu parent: 'Dashboard', priority: 1

  # permit_params :id

  def index
    authorize :reports, :index?
  end

    content title: "Reports" do
      columns do
        panel "queries" do
          ul do
            li link_to "Legacy OS records with review dates equal to next month", admin_legacy_os_records_review_date_next_month_path
          end
          ul do
            li "Systems with selected data type"
            render partial: "admin/reports/data_type"
          end

        end
      end
    end # content

    controller do
      def legacy_os_records_review_date_next_month
        sql = "Select support_poc, owner_username, legacy_os, hostname
          FROM legacy_os_records AS lor JOIN devices AS dev on lor.device_id = dev.id
          WHERE IF(MONTH(CURRENT_DATE()) = 12, (MONTH(review_date) = 1 AND YEAR(review_date) = YEAR(CURRENT_DATE()) +1),
          (MONTH(review_date) = MONTH(CURRENT_DATE())+1) AND YEAR(review_date) = YEAR(CURRENT_DATE())) AND lor.deleted_at IS NULL"
        records_array = ActiveRecord::Base.connection.exec_query(sql)
        new_csv(sql, records_array, "legacy_os_records_review_date_next_month")
      end

      def systems_with_selected_data_type
        csv = []
        data_type = DataType.find(params[:id]).name
        csv.push("Systems with " + data_type + " data type\n\n")
        csv.push("dpa_exceptions\n\n")
        sql = "SELECT used_by, third_party_product_service FROM dpa_exceptions WHERE deleted_at IS NULL AND data_type_id = " + params[:id]        
        records_array = ActiveRecord::Base.connection.exec_query(sql)
        header = records_array.columns.join(", ")  + "\n"
        csv.push(header)
        records_array.each do |row|
          csv.push(row.values.join(", ")  + "\n")
        end
        csv.push("\n\n")

        csv.push("it_security_incidents\n\n")
        sql = "SELECT title, people_involved, equipment_involved FROM it_security_incidents WHERE deleted_at IS NULL AND data_type_id = " + params[:id]
        records_array = ActiveRecord::Base.connection.exec_query(sql)
        header = records_array.columns.join(", ")  + "\n"
        csv.push(header)
        records_array.each do |row|
          csv.push(row.values.join(", ")  + "\n")
        end
        csv.push("\n\n")

        csv.push("legacy_os_records\n\n")
        sql = "SELECT owner_username, legacy_os, hostname
        FROM legacy_os_records as lor join devices as dev on lor.device_id = dev.id WHERE lor.deleted_at IS NULL AND data_type_id = " + params[:id]
        records_array = ActiveRecord::Base.connection.exec_query(sql)
        header = records_array.columns.join(", ")  + "\n"
        csv.push(header)
        records_array.each do |row|
          csv.push(row.values.join(", ")  + "\n")
        end
        csv.push("\n\n")

        csv.push("sensitive_data_systems\n\n")
        sql = "SELECT name, owner_username, (SELECT storage_locations.name FROM storage_locations WHERE sd.storage_location_id = storage_locations.id) AS storage_location, hostname
        FROM sensitive_data_systems AS sd JOIN devices as dev on sd.device_id = dev.id WHERE sd.deleted_at IS NULL AND data_type_id = " + params[:id]
        records_array = ActiveRecord::Base.connection.exec_query(sql)
        header = records_array.columns.join(", ")  + "\n"
        csv.push(header)
        records_array.each do |row|
          csv.push(row.values.join(", ")  + "\n")
        end

        send_csv(csv, "systems_with_selected_data_type")
      end

      def new_csv(sql, records_array, title)
        csv = []
        # records_array = ActiveRecord::Base.connection.exec_query(sql)
        header = records_array.columns.join(", ")  + "\n"
        csv.push(header)
        records_array.each do |row|
          csv.push(row.values.join(", ")  + "\n")
        end
        sql_data_as_string = csv.join("")

        respond_to do |format|
          format.html { send_data sql_data_as_string.force_encoding("UTF-8"), filename: "#{title}-#{Date.today}.csv" }
        end
      end

      def send_csv(csv, title)
        sql_data_as_string = csv.join("")

        respond_to do |format|
          format.html { send_data sql_data_as_string.force_encoding("UTF-8"), filename: "#{title}-#{Date.today}.csv" }
        end
      end

      def permitted_params
        params.permit!
        # params.permit! # allow all parameters
      end

    end

end