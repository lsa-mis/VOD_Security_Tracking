module ActiveAdmin
  class AdminPolicy
    attr_reader :user, :record

    def initialize(user, record)
      raise Pundit::NotAuthorizedError, "must be logged in" unless user
      @user = user
      @record = record
      get_admin_groups
      # Rails.logger.debug "************************** membership #{$membership}"
    end

    def index?
      true
      # ($membership & @admins_groups).any?
    end

    def show?
      ($membership & @admins_groups).any?
    end

    def create?
      ($membership & @admins_groups).any?
    end

    def new?
      create?
    end

    def update?
      # ($membership & @admins_groups).any?
      true
    end

    def edit?
      update?
    end

    def destroy?
      ($membership & @admins_groups).any?
    end

    def get_admin_groups
      @admins_groups = ['lsa-vod-devs-unprivileged']
      # @admins_groups = ['lsa-vod-admins', 'lsa-vod-devs']
    end


    class Scope < Struct.new(:user, :scope)
      def resolve
        scope
      end
    end
  end

end