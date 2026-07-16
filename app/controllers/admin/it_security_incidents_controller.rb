module Admin
  class ItSecurityIncidentsController < BaseController
    include Admin::ReadOnlyActions

    private

    def apply_admin_scope(scope)
      @current_scope = (params[:scope].presence || "active").to_sym
      case @current_scope
      when :archived then scope.archived
      else scope.active
      end
    end

    def render_csv(scope)
      # Main app to_csv ignores scope; export scoped rows manually via model columns when needed
      if ItSecurityIncident.respond_to?(:to_csv) && @current_scope.to_s == "active" && params[:q].blank?
        send_data ItSecurityIncident.to_csv, filename: "it-security-incidents-#{Date.current}.csv", type: "text/csv"
      else
        export_csv(scope, ItSecurityIncident.column_names, filename: "it-security-incidents-#{Date.current}.csv") do |csv, record|
          csv << ItSecurityIncident.column_names.map { |attr| record.public_send(attr) }
        end
      end
    end
  end
end
