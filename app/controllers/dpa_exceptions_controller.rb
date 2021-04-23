class DpaExceptionsController < InheritedResources::Base
  devise_group :logged_in, contains: [:user, :admin]
  before_action :authenticate_logged_in!

  def index
    @dpa_exceptions = DpaException.active
  end

  def archive
    @dpa_exception = DpaException.find(params[:id])
    authorize @dpa_exception
    @dpa_exception.archive
    respond_to do |format|
      format.html { redirect_to dpa_exceptions_path, notice: 'dpa exception record was successfully archived.' }
      format.json { head :no_content }
    end
  end
  
  def audit_log
    @dpa_exceptions = DpaException.all
  end

  private

    def dpa_exception_params
      params.require(:dpa_exception).permit(:review_date, :third_party_product_service, :used_by, :point_of_contact, :review_findings, :review_summary, :lsa_security_recommendation, :lsa_security_determination, :lsa_security_approval, :lsa_technology_services_approval, :exception_approval_date, :notes, :sla_agreement, :sla_attachment, :data_type_id, attachments: [])
    end

end
