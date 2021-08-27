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
  
    def show?
      get_ldap_groups('dpa_exceptions')
      (user.membership & @ldap_groups).any?
    end  

    def new?
      get_ldap_groups('dpa_exceptions', 'newedit')
      (user.membership & @ldap_groups).any?
    end

    def archive?
      get_ldap_groups('dpa_exceptions', 'archive')
      (user.membership & @ldap_groups).any?
    end

    def edit?
      get_ldap_groups('dpa_exceptions', 'newedit')
      (user.membership & @ldap_groups).any?
    end

    def audit_log?
      get_ldap_groups('dpa_exceptions', 'audit')
      (user.membership & @ldap_groups).any?
    end

    def any_action?
      get_ldap_groups('dpa_exceptions')
      (user.membership & @ldap_groups).any?
    end

  end