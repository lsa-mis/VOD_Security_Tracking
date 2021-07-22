class ApplicationSettingPolicy < ApplicationPolicy
    attr_reader :user, :application_setting
  
    def initialize(user, application_setting)
      @user = user
      @application_setting = application_setting
    end

    def index?
      get_ldap_groups('application_settings')
      (user.membership & @ldap_groups).any?
    end
  
    def show?
      get_ldap_groups('application_settings')
      (user.membership & @ldap_groups).any?
    end  

    def new?
      get_ldap_groups('application_settings', 'newedit_action')
      (user.membership & @ldap_groups).any?
    end

    def edit?
      get_ldap_groups('application_settings', 'newedit_action')
      a = (user.membership & @ldap_groups).any?
      (user.membership & @ldap_groups).any?
    end

  end