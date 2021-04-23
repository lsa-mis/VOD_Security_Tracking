class SensitiveDataSystemPolicy
    attr_reader :user, :sensitive_data_system
  
    def initialize(user, sensitive_data_system)
      @user = user
      @sensitive_data_system = sensitive_data_system
    end
  
    # def update?
    #   user.user? 
    # end

    def archive?
        user.role == 'can_delete'
      end
  end