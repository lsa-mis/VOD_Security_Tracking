class ApplicationPolicy
  attr_reader :user, :record

  def initialize(user, record)
    raise Pundit::NotAuthorizedError, "must be logged in" unless user
    @user = user
    @record = record
  end

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
  class Scope < Struct.new(:user, :scope)
    def resolve
      scope
    end
  end
end
