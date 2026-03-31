class ApplicationController < ActionController::Base
  before_action :set_breadcrumbs
  before_action :set_membership
  before_action :set_sentry_user_context

  include Pagy::Backend
  include Pundit::Authorization

  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized
  rescue_from DeviseLdapAuthenticatable::LdapException, with: :ldap_error_handler
  rescue_from Net::LDAP::Error, with: :ldap_error_handler

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

    def set_sentry_user_context
      return unless user_signed_in? && defined?(Sentry)

      Sentry.set_user(id: current_user.id.to_s)
    end

    def set_membership
      begin
        @admin_access = false

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
      message = exception.message.to_s
      Rails.logger.error "LDAP Error: #{message}"

      if ldap_invalid_credentials?(message)
        flash[:alert] = "LDAP authentication failed. Please check your credentials."
        redirect_to new_user_session_path
      elsif ldap_service_unavailable?(message)
        flash[:alert] = "Cannot reach LDAP right now. Connect to VPN or campus network and try again."
        redirect_to new_user_session_path
      else
        raise exception
      end
    end

    def ldap_invalid_credentials?(message)
      message.include?("Not authorized because not authenticated") ||
        message.include?("Not authorized because of invalid credentials")
    end

    def ldap_service_unavailable?(message)
      normalized = message.downcase
      normalized.include?("timed out") ||
        normalized.include?("connection refused") ||
        normalized.include?("network is unreachable") ||
        normalized.include?("no route to host")
    end
end
