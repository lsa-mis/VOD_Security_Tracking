module Admin
  class ApplicationPolicy
    attr_reader :user, :record

    def initialize(user, record)
      raise Pundit::NotAuthorizedError, "must be logged in" unless user

      @user = user
      @record = record
    end

    def index?
      admin?
    end

    def show?
      admin?
    end

    def create?
      admin?
    end

    def new?
      create?
    end

    def update?
      admin?
    end

    def edit?
      update?
    end

    def destroy?
      admin?
    end

    def batch_destroy?
      destroy?
    end

    class Scope < Struct.new(:user, :scope)
      def resolve
        scope
      end
    end

    private

    def admin?
      (Array(user.membership) & admin_groups).any?
    end

    def admin_groups
      AccessLookup.where(vod_table: "admin_interface").pluck(:ldap_group)
    end
  end
end
