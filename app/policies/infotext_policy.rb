class InfotextPolicy < ApplicationPolicy
    attr_reader :user, :infotext
  
    def initialize(user, infotext)
      @user = user
      @infotext = infotext
    end

    def index?
      get_ldap_groups('admin_interface')
      (user.membership & @ldap_groups).any?
    end
  
    def show?
      get_ldap_groups('admin_interface')
      (user.membership & @ldap_groups).any?
    end  

    def new?
      get_ldap_groups('admin_interface', 'newedit')
      (user.membership & @ldap_groups).any?
    end

    def edit?
      get_ldap_groups('admin_interface', 'newedit')
      a = (user.membership & @ldap_groups).any?
      (user.membership & @ldap_groups).any?
    end

  end