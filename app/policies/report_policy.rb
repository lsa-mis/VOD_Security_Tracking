class ReportPolicy < ApplicationPolicy
    attr_reader :user, :report
  
    def initialize(user, report)
      @user = user
      @report = report
    end

    def index?
      get_ldap_groups('admin_interface')
      (user.membership & @ldap_groups).any?
    end
  
    def show?
      get_ldap_groups('admin_interface')
      (user.membership & @ldap_groups).any?
    end  

  end