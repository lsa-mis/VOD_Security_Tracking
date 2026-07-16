module Admin
  class NotificationsController < BaseController
    include Admin::CrudActions

    private

    def resource_params
      params.require(:notification).permit(:note, :opendate, :closedate, :notetype)
    end
  end
end
