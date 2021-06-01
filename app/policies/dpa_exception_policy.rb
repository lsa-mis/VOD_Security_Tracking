class DpaExceptionPolicy < ApplicationPolicy
    attr_reader :user, :dpa_exception
  
    def initialize(user, dpa_exception)
      @user = user
      @dpa_exception = dpa_exception
    end

    def new?
      get_ldap_groups('dpa_exceptions', 'new_action')
      if (user.membership & @ldap_group).any?
        return true
      else 
        return false
      end
    end

    def archive?
      get_ldap_groups('dpa_exceptions', 'archive_action')
      if (user.membership & @ldap_group).any?
        return true
      else 
        return false
      end
    end

    def edit?
      get_ldap_groups('dpa_exceptions', 'edit_action')
      if (user.membership & @ldap_group).any?
        return true
      else 
        return false
      end
    end

    def show?
      get_ldap_groups('dpa_exceptions', 'show_action')
      if (user.membership & @ldap_group).any?
        return true
      else 
        return false
      end
    end
  end