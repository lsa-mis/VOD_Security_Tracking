class ApplicationController < ActionController::Base
  before_action :set_breadcrumbs
  before_action :set_membership

  include Pagy::Backend

  include Pundit
  after_action :verify_authorized, except: :index, unless: :active_admin_controller?
  after_action :verify_policy_scoped, except: :index, unless: :active_admin_controller?
  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  rescue_from DeviseLdapAuthenticatable::LdapException do |exception|
    render :text => exception, :status => 500
  end

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

  private

    def set_membership
      if user_signed_in?
        current_user.membership = session[:user_memberships]
        $membership = session[:user_memberships]
      else
        new_user_session_path
      end
    end

    def set_breadcrumbs
      @breadcrumbs = []
    end

    def after_sign_in_path_for(resource)
      duo_path
      # dashboard_path
    end  

    def user_not_authorized
      flash[:alert] = "You are not authorized to perform this action."
      redirect_to(request.referrer || root_path)
    end

    def active_admin_controller?
      is_a?(ActiveAdmin::BaseController) || is_a?(StaticPagesController) || is_a?(DeviseController)
    end
end
