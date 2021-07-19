module ActiveAdmin
  class DashboardPolicy < AdminPolicy
    def dashboard?
      ($membership & @admins_groups).any?
    end

    def index?
      ($membership & @admins_groups).any?
    end
  end
end
 