module Admin
  class BaseController < ApplicationController
    layout "admin"

    before_action :authenticate_user!
    before_action :authorize_admin!

    rescue_from Pundit::NotAuthorizedError, with: :admin_access_denied

    helper AdminHelper

    private

    def authorize_admin!
      unless Admin::DashboardPolicy.new(current_user, :dashboard).show?
        raise Pundit::NotAuthorizedError, "not allowed to access admin"
      end
    end

    def authorize_resource(record = nil)
      record ||= resource_class
      authorize record, policy_class: Admin::ApplicationPolicy
    end

    def resource_class
      controller_name.classify.constantize
    end

    def apply_ransack(scope)
      @q = scope.ransack(params[:q])
      @q.result
    end

    def paginate(scope)
      @pagy, records = pagy(scope)
      records
    end

    def export_csv(records, headers, filename:)
      require "csv" unless defined?(CSV)
      data = CSV.generate(headers: true) do |csv|
        csv << headers
        records.find_each do |record|
          yield csv, record
        end
      end
      send_data data, filename: filename, type: "text/csv"
    end
  end
end
