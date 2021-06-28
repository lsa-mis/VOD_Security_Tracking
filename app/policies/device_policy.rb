class DevicePolicy < ApplicationPolicy
    attr_reader :user, :device
  
    def initialize(user, device)
      @user = user
      @device = device
    end

    def index?
      get_ldap_groups('devices')
      (user.membership & @ldap_groups).any?
    end
  
    def show?
      get_ldap_groups('devices')
      (user.membership & @ldap_groups).any?
    end  

    def new?
      get_ldap_groups('devices', 'newedit_action')
      (user.membership & @ldap_groups).any?
    end

    def archive?
      get_ldap_groups('devices', 'archive_action')
      (user.membership & @ldap_groups).any?
    end

    def edit?
      get_ldap_groups('devices', 'newedit_action')
      (user.membership & @ldap_groups).any?
    end

    def audit_log?
      get_ldap_groups('devices', 'audit_action')
      (user.membership & @ldap_groups).any?
    end

    def destroy?
      get_ldap_groups('devices', 'archive_action')
      (user.membership & @ldap_groups).any?
    end

  end