class ApplicationController < ActionController::Base
  class Responder < ActionController::Responder
    def to_turbo_stream
      controller.render(options.merge(formats: :html))
      rescue ActionView::MissingTemplate => error
      if get?
          raise error
      elsif has_errors? && default_action
          render rendering_options.merge(formats: :html, status: :unprocessable_entity)
      else
          redirect_to navigation_location
      end
    end
  end
  
  self.responder = Responder
  respond_to :html, :turbo_stream

  before_action :set_breadcrumbs

  include Pundit
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
      current_user.membership = session[:user_memberships]
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
end
