class SensitiveDataSystemPolicy < ApplicationPolicy
    attr_reader :user, :sensitive_data_system
  
    def initialize(user, sensitive_data_system)
      @user = user
      @sensitive_data_system = sensitive_data_system
    end

    def index?
      get_ldap_groups('sensitive_data_systems')
      (user.membership & @ldap_groups).any?
    end

    def show?
      get_ldap_groups('sensitive_data_systems')
      (user.membership & @ldap_groups).any?
    end
  
    def new?
      get_ldap_groups('sensitive_data_systems', 'newedit_action')
      (user.membership & @ldap_groups).any?
    end

    def archive?
      get_ldap_groups('sensitive_data_systems', 'archive_action')
      (user.membership & @ldap_groups).any?
    end

    def edit?
      get_ldap_groups('sensitive_data_systems', 'newedit_action')
      (user.membership & @ldap_groups).any?
    end

    def audit_log?
      get_ldap_groups('sensitive_data_systems', 'audit_action')
      (user.membership & @ldap_groups).any?
    end
  end