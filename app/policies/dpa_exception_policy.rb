class DpaExceptionPolicy < ApplicationPolicy
    attr_reader :user, :dpa_exception
  
    def initialize(user, dpa_exception)
      @user = user
      @dpa_exception = dpa_exception
    end

    def new?
      get_ldap_groups('dpa_exceptions', 'newedit_action')
      (user.membership & @ldap_group).any?
    end

    def archive?
      get_ldap_groups('dpa_exceptions', 'archive_action')
      (user.membership & @ldap_group).any?
    end

    def edit?
      get_ldap_groups('dpa_exceptions', 'newedit_action')
      (user.membership & @ldap_group).any?
    end

    # def show?
    #   get_ldap_groups('dpa_exceptions', 'show_action')
    #   (user.membership & @ldap_group).any?
    # end
  end