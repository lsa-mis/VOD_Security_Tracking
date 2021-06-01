class ItSecurityIncidentPolicy < ApplicationPolicy
    attr_reader :user, :it_security_incident
  
    def initialize(user, it_security_incident)
      @user = user
      @it_security_incident = it_security_incident
    end

    def new?
      get_ldap_groups('it_security_incidents', 'new_action')
      (user.membership & @ldap_group).any?
    end

    def archive?
      get_ldap_groups('it_security_incidents', 'archive_action')
      (user.membership & @ldap_group).any?
    end

    def edit?
      get_ldap_groups('it_security_incidents', 'edit_action')
      (user.membership & @ldap_group).any?
    end

    def show?
      get_ldap_groups('it_security_incidents', 'show_action')
      (user.membership & @ldap_group).any?
    end
    
  end