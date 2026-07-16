module Admin
  module ReadOnlyActions
    extend ActiveSupport::Concern

    included do
      before_action :set_resource, only: %i[show]
    end

    def index
      authorize_resource
      scope = filtered_scope
      respond_to do |format|
        format.html { @resources = paginate(scope) }
        format.csv { render_csv(scope) }
      end
    end

    def show
      authorize_resource @resource
    end

    private

    def set_resource
      @resource = resource_class.find(params[:id])
    end

    def filtered_scope
      scope = resource_class.all
      scope = apply_admin_scope(scope) if respond_to?(:apply_admin_scope, true)
      if admin_filters_enabled?
        apply_ransack(scope)
      else
        @q = scope.ransack
        scope
      end
    end

    def admin_filters_enabled?
      false
    end

    def csv_headers
      resource_class.column_names
    end

    def render_csv(scope)
      if resource_class.respond_to?(:to_csv)
        send_data resource_class.to_csv, filename: "#{resource_class.model_name.plural}-#{Date.current}.csv", type: "text/csv"
      else
        export_csv(scope, csv_headers, filename: "#{resource_class.model_name.plural}-#{Date.current}.csv") do |csv, record|
          csv << csv_headers.map { |attr| record.public_send(attr) }
        end
      end
    end
  end
end
