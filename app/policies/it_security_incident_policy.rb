class ItSecurityIncidentPolicy < ApplicationPolicy
    attr_reader :user, :it_security_incident
  
    def initialize(user, it_security_incident)
      @user = user
      @it_security_incident = it_security_incident
    end

    def index?
      get_ldap_groups('it_security_incidents')
      (user.membership & @ldap_groups).any?
    end

    def show?
      get_ldap_groups('it_security_incidents')
      (user.membership & @ldap_groups).any?
    end 

    def new?
      get_ldap_groups('it_security_incidents', 'newedit_action')
      (user.membership & @ldap_groups).any?
    end

    def archive?
      get_ldap_groups('it_security_incidents', 'archive_action')
      (user.membership & @ldap_groups).any?
    end

    def edit?
      get_ldap_groups('it_security_incidents', 'newedit_action')
      (user.membership & @ldap_groups).any?
    end
    
    def audit_log?
      get_ldap_groups('it_security_incidents', 'audit_action')
      (user.membership & @ldap_groups).any?
    end

    def any_action?
      get_ldap_groups('it_security_incidents')
      (user.membership & @ldap_groups).any?
    end

  end