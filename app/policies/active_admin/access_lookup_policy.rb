module ActiveAdmin
  class AccessLookupPolicy < AdminPolicy
    attr_reader :user, :record

    def index?
      # true
      ($membership & @admins_groups).any?
    end

    def show?
      # true
      ($membership & @admins_groups).any?
    end

    def create?
      # true
      ($membership & @admins_groups).any?
    end

    def new?
      create?
    end

    def update?
      ($membership & @admins_groups).any?
      # true
    end

    def edit?
      update?
    end

    def destroy?
      # true
      ($membership & @admins_groups).any?
    end
  end
end