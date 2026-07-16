module Admin
  class DashboardController < BaseController
    def show
      @recent_users = User.recent
      @notifications = Notification.active
    end
  end
end
