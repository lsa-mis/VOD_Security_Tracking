class DpaExceptionPolicy < ApplicationPolicy
    attr_reader :user, :dpa_exception
  
    def initialize(user, dpa_exception)
      @user = user
      @dpa_exception = dpa_exception
    end

    def index?
      get_ldap_groups('dpa_exceptions')
      (user.membership & @ldap_groups).any?
    end

    def new?
      get_ldap_groups('dpa_exceptions', 'newedit_action')
      (user.membership & @ldap_groups).any?
    end

    def archive?
      get_ldap_groups('dpa_exceptions', 'archive_action')
      (user.membership & @ldap_groups).any?
    end

    def edit?
      get_ldap_groups('dpa_exceptions', 'newedit_action')
      (user.membership & @ldap_groups).any?
    end

    def audit_log?
      get_ldap_groups('dpa_exceptions', 'audit_action')
      (user.membership & @ldap_groups).any?
    end
  end