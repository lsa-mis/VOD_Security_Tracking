class ApplicationController < ActionController::Base
  before_action :set_breadcrumbs
  before_action :set_membership

  include Pagy::Backend
  include Pundit::Authorization

  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized
  rescue_from DeviseLdapAuthenticatable::LdapException, with: :ldap_error_handler

  def add_breadcrumb(label, path = nil)
    @breadcrumbs << {
      label: label,
      path: path
    }
  end

  def verify_duo_authentication
    if !session[:duo_auth]
      redirect_to duo_path
    end
  end

  def delete_file_attachment
    @delete_file = ActiveStorage::Attachment.find(params[:id])
    @delete_file.purge
    redirect_back(fallback_location: request.referer)
  end

  def admin_access_denied(exception)
    flash[:alert] = "You are not authorized to perform this action."
    redirect_to(request.referrer || root_path)
  end

  private

    def set_membership
      begin
        if user_signed_in?
          current_user.membership = session[:user_memberships]
          if current_user.membership.present?
            depts_groups = Department.all.pluck(:active_dir_group).compact_blank
            current_user.dept_membership = current_user.membership & depts_groups
            admins_groups = AccessLookup.where(vod_table: 'admin_interface').pluck(:ldap_group)
            @admin_access = (current_user.membership & admins_groups).any?
          end
        else
          new_user_session_path
        end
      rescue StandardError => e
        flash[:alert] = "There was a problem with your membership. Be sure your VPN is running or you are using a campus IP and try again"
        redirect_to root_path
      end
    end

    def set_breadcrumbs
      @breadcrumbs = []
    end

    def after_sign_in_path_for(resource)
      duo_path
    end  

    def user_not_authorized
      flash[:alert] = "You are not authorized to perform this action."
      redirect_to(request.referrer || root_path)
    end

    def ldap_error_handler(exception)
      Rails.logger.error "LDAP Error: #{exception.message}"
      if exception.message.include?("Not authorized because not authenticated") ||
         exception.message.include?("Not authorized because of invalid credentials")
        flash[:alert] = "LDAP authentication failed. Please check your credentials."
        redirect_to new_user_session_path
      else
        raise exception
      end
    end
end
