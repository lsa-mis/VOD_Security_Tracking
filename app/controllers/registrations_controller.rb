class RegistrationsController < Devise::RegistrationsController
  skip_before_action :require_no_authentication, only: [:duo_verify]
  skip_before_action :verify_authenticity_token

  self.responder = Responder
  respond_to :html, :turbo_stream
  
  def duo
    @sig_request = Duo.sign_request(Rails.application.credentials.duo[:duo_ikey], Rails.application.credentials.duo[:duo_skey], Rails.application.credentials.duo[:duo_akey], current_user.username)
  end

  def duo_verify
    @authenticated_user = Duo.verify_response(Rails.application.credentials.duo[:duo_ikey], Rails.application.credentials.duo[:duo_skey], Rails.application.credentials.duo[:duo_akey], params['sig_response'])
    if @authenticated_user
      session[:duo_auth] = true
      redirect_to dashboard_path
    else
      redirect_to unauthenticated_root_path
    end
  end

end
