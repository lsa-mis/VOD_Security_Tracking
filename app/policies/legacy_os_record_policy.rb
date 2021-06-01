class LegacyOsRecordPolicy < ApplicationPolicy
    attr_reader :user, :legacy_os_record
  
    def initialize(user, legacy_os_record)
      @user = user
      @legacy_os_record = legacy_os_record
    end

    def new?
      get_ldap_groups('legacy_os_records', 'new_action')
      (user.membership & @ldap_group).any?
    end

    def archive?
      get_ldap_groups('legacy_os_records', 'archive_action')
      (user.membership & @ldap_group).any?
    end

    def edit?
      get_ldap_groups('legacy_os_records', 'edit_action')
      (user.membership & @ldap_group).any?
    end

    def show?
      get_ldap_groups('legacy_os_records', 'show_action')
      (user.membership & @ldap_group).any?
    end

  end