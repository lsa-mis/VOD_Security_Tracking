module ActiveAdmin
  class DashboardPolicy < AdminPolicy
    def dashboard?
      (user.membership & @admins_groups).any?
    end

    def index?
      (user.membership & @admins_groups).any?
    end
  end
end
 