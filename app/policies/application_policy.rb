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

  def get_ldap_groups(table, action=nil)
    case action
    when  'newedit_action',
          'show_action',
          'archive_action',
          'audit_action'
      @ldap_groups = AccessLookup.where(table: table, action: action).or(AccessLookup.where(table: table, action: 'all_actions')).pluck(:ldap_group)
    when nil
      @ldap_groups = AccessLookup.where(table: table).pluck(:ldap_group)
    else
      @ldap_groups = []
    end
  end
end
