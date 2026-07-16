module Admin
  class DpaExceptionsController < BaseController
    include Admin::ReadOnlyActions

    private

    def apply_admin_scope(scope)
      @current_scope = (params[:scope].presence || "active").to_sym
      case @current_scope
      when :archived then scope.archived
      else scope.active
      end
    end
  end
end
