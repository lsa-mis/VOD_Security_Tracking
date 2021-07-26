class ApplicationPolicy
  attr_reader :user, :record

  def initialize(user, record)
    raise Pundit::NotAuthorizedError, "must be logged in" unless user
    @user = user
    @record = record
  end

  def get_ldap_groups(table, action=nil)
    case action
    when  'newedit',
          'show',
          'archive',
          'audit'
      @ldap_groups = AccessLookup.where(vod_table: table, vod_action: action).or(AccessLookup.where(vod_table: table, vod_action: 'all')).pluck(:ldap_group)
    when nil
      @ldap_groups = AccessLookup.where(vod_table: table).pluck(:ldap_group)
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
