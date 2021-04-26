class LegacyOsRecordPolicy
    attr_reader :user, :legacy_os_record
  
    def initialize(user, legacy_os_record)
      @user = user
      @legacy_os_record = legacy_os_record
    end

    def archive?
        user.role == 'can_delete'
      end
  end