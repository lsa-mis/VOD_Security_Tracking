class DpaExceptionPolicy
    attr_reader :user, :dpa_exception
  
    def initialize(user, dpa_exception)
      @user = user
      @dpa_exception = dpa_exception
    end

    def new?
      ldap_group = AccessLookup.find_by(table: "dpa_exceptions", action: "new").ldap_group
      if user.membership.include? ldap_group
        return true
      else 
        return false
      end
    end

    def archive?
      ldap_group = AccessLookup.find_by(table: "dpa_exceptions", action: "archive").ldap_group
      if user.membership.include? ldap_group
        return true
      else 
        return false
      end
    end
  end