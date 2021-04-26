class DpaExceptionPolicy
    attr_reader :user, :dpa_exception
  
    def initialize(user, dpa_exception)
      @user = user
      @dpa_exception = dpa_exception
    end

    def archive?
        user.role == 'can_delete'
      end
  end