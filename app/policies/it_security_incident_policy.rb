class ItSecurityIncidentPolicy
    attr_reader :user, :it_security_incident
  
    def initialize(user, it_security_incident)
      @user = user
      @it_security_incident = it_security_incident
    end
  
    # def update?
    #   user.user? 
    # end

    def archive?
        user.role == 'can_delete'
      end
  end