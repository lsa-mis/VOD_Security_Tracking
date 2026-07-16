module Admin
  class DashboardPolicy < ApplicationPolicy
    def show?
      admin?
    end
  end
end
