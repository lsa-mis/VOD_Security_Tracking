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
        membership = []
        groups = Devise::LDAP::Adapter.get_ldap_param(current_user.username,'memberOf')
        groups.each do |group|
          g = group.split(',')
          membership.append(g.first.remove("CN="))
        end
        session[:user_memberships] = membership
        # logger.debug "*********** session[:user_memberships] ***** #{session[:user_memberships]}"
      end
    end
end
