# frozen_string_literal: true

class Users::SessionsController < Devise::SessionsController

   before_action :configure_sign_in_params, only: [:create]
   after_action :after_login

  # GET /resource/sign_in
   def new
     super
   end

  # POST /resource/sign_in
   def create
     super
   end

  # DELETE /resource/sign_out
   def destroy
     super
   end

   protected

  # If you have extra params to permit, append them to the sanitizer.
   def configure_sign_in_params
     devise_parameter_sanitizer.permit(:sign_in, keys: [:username, :email, :membership])
   end


   private

    def after_login
      if user_signed_in?
        ldap_config = { :host => "adsroot.itcs.umich.edu", :port => 389, :encryption => nil, :base_dn => "OU=UMICH,DC=adsroot,DC=itcs,DC=umich,DC=edu",
                :group_base => "OU=UMICH,DC=adsroot,DC=itcs,DC=umich,DC=edu", :attr_login => "sAMAccountName", :server_type => :active_directory,
                :service_user => Rails.application.credentials.ldap_admin[:user], :search_filter => "(objectClass=*)", :service_pass => Rails.application.credentials.ldap_admin[:password],
                :anon_queries => false }

        fluff = LdapFluff.new(ldap_config)
        membership = []
        # groups = Devise::LDAP::Adapter.get_ldap_param(current_user.username,'memberOf')
        # groups.each do |group|
        #   g = group.split(',')
        #   membership.append(g.first.remove("CN="))
        # end
        access_groups = AccessLookup.pluck(:ldap_group).uniq
        access_groups.each do |group|
          if fluff.is_in_groups?(current_user.username,Array.wrap(group))
            membership.append(group)
          end
        end
        Rails.logger.debug "********************* membership #{membership}"
        session[:user_memberships] = membership
      end
    end
end
