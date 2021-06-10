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
      get_ldap_groups('legacy_os_records', 'newedit_action')
      (user.membership & @ldap_groups).any?
    end

    def archive?
      get_ldap_groups('legacy_os_records', 'archive_action')
      (user.membership & @ldap_groups).any?
    end

    def edit?
      get_ldap_groups('legacy_os_records', 'newedit_action')
      (user.membership & @ldap_groups).any?
    end

  end