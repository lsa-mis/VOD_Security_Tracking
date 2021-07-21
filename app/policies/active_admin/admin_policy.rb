module ActiveAdmin
  class AdminPolicy
    attr_reader :user, :record

    def initialize(user, record)
      raise Pundit::NotAuthorizedError, "must be logged in" unless user
      @user = user
      @record = record
      get_admin_groups
    end

    def index?
      (user.membership & @admins_groups).any?
    end

    def show?
      (user.membership & @admins_groups).any?
    end

    def create?
      (user.membership & @admins_groups).any?
    end

    def new?
      create?
    end

    def update?
      (user.membership & @admins_groups).any?
    end

    def edit?
      update?
    end

    def destroy?
      (user.membership & @admins_groups).any?
    end

    def get_admin_groups
      @admins_groups = AccessLookup.where(table: 'admin_interface').pluck(:ldap_group)
    end

    class Scope < Struct.new(:user, :scope)
      def resolve
        scope
      end
    end
  end

end