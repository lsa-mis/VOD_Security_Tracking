module Admin
  class DevicesController < BaseController
    include Admin::ReadOnlyActions

    def batch_destroy
      authorize Device, :batch_destroy?, policy_class: Admin::ApplicationPolicy
      ids = Array(params[:ids]).map(&:presence).compact
      Device.where(id: ids).find_each(&:destroy!)
      redirect_to admin_devices_path, notice: "Selected devices deleted."
    end

    private

    def apply_admin_scope(scope)
      @current_scope = (params[:scope].presence || "all").to_sym
      case @current_scope
      when :incomplete then scope.incomplete
      else scope.all
      end
    end

    def admin_filters_enabled?
      true
    end
  end
end
