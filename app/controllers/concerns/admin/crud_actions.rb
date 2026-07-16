module Admin
  module CrudActions
    extend ActiveSupport::Concern

    included do
      before_action :set_resource, only: %i[show edit update destroy]
    end

    def index
      authorize_resource
      scope = filtered_scope
      respond_to do |format|
        format.html do
          @resources = paginate(scope)
        end
        format.csv { render_csv(scope) }
      end
    end

    def show
      authorize_resource @resource
    end

    def new
      @resource = resource_class.new
      authorize_resource @resource
    end

    def create
      @resource = resource_class.new(resource_params)
      authorize_resource @resource
      if @resource.save
        redirect_to [:admin, @resource], notice: "#{resource_class.model_name.human} created."
      else
        render :new, status: :unprocessable_entity
      end
    end

    def edit
      authorize_resource @resource
    end

    def update
      authorize_resource @resource
      if @resource.update(resource_params)
        redirect_to [:admin, @resource], notice: "#{resource_class.model_name.human} updated."
      else
        render :edit, status: :unprocessable_entity
      end
    end

    def destroy
      authorize_resource @resource
      @resource.destroy!
      redirect_to [:admin, resource_class], notice: "#{resource_class.model_name.human} deleted."
    end

    def batch_destroy
      authorize_resource
      ids = Array(params[:ids]).map(&:presence).compact
      resource_class.where(id: ids).find_each(&:destroy!)
      redirect_to [:admin, resource_class], notice: "Selected #{resource_class.model_name.human.pluralize} deleted."
    end

    private

    def set_resource
      @resource = resource_class.find(params[:id])
    end

    def filtered_scope
      scope = resource_class.all
      if respond_to?(:apply_admin_scope, true)
        scope = apply_admin_scope(scope)
      end
      if admin_filters_enabled?
        apply_ransack(scope)
      else
        @q = scope.ransack
        scope
      end
    end

    def admin_filters_enabled?
      true
    end

    def resource_params
      raise NotImplementedError
    end

    def csv_headers
      resource_class.column_names
    end

    def render_csv(scope)
      export_csv(scope, csv_headers, filename: "#{resource_class.model_name.plural}-#{Date.current}.csv") do |csv, record|
        csv << csv_headers.map { |attr| record.public_send(attr) }
      end
    end
  end
end
