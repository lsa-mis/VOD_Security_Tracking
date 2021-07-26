class LegacyOsRecordPolicy < ApplicationPolicy
    attr_reader :user, :legacy_os_record
  
    def initialize(user, legacy_os_record)
      @user = user
      @legacy_os_record = legacy_os_record
    end

    def index?
      get_ldap_groups('legacy_os_records')
      (user.membership & @ldap_groups).any?
    end

    def show?
      get_ldap_groups('legacy_os_records')
      (user.membership & @ldap_groups).any?
    end

    def new?
      get_ldap_groups('legacy_os_records', 'newedit')
      (user.membership & @ldap_groups).any?
    end

    def archive?
      get_ldap_groups('legacy_os_records', 'archive')
      (user.membership & @ldap_groups).any?
    end

    def edit?
      get_ldap_groups('legacy_os_records', 'newedit')
      (user.membership & @ldap_groups).any?
    end

    def audit_log?
      get_ldap_groups('legacy_os_records', 'audit')
      (user.membership & @ldap_groups).any?
    end

    def any_action?
      get_ldap_groups('legacy_os_records')
      (user.membership & @ldap_groups).any?
    end

  end