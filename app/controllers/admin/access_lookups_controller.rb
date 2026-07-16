module Admin
  class AccessLookupsController < BaseController
    include Admin::CrudActions

    private

    def resource_params
      params.require(:access_lookup).permit(:ldap_group, :vod_table, :vod_action)
    end
  end
end
