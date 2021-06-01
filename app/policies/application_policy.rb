class ApplicationPolicy
  attr_reader :user, :record

  def initialize(user, record)
    raise Pundit::NotAuthorizedError, "must be logged in" unless user
    @user = user
    @record = record
  end

  # def index?
  #   false
  # end

  # def show?
  #   false
  # end

  # def create?
  #   false
  # end

  # # def new?
  # #   create?
  # # end

  # # def new?
  # #   ldap_group = AccessLookup.where(table: "dpa_exceptions", action: "new").pluck(:ldap_group)
  # #   if (user.membership & ldap_group).any?
  # #     return true
  # #   else 
  # #     return false
  # #   end
  # # end

  # def update?
  #   false
  # end

  # def edit?
  #   update?
  # end

  # def destroy?
  #   false
  # end

  def get_ldap_groups(table, action)
    @ldap_group = AccessLookup.where(table: table, :action => [action, 'all_actions']).pluck(:ldap_group)
  end
end
