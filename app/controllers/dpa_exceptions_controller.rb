class DpaExceptionsController < InheritedResources::Base

  devise_group :logged_in, contains: [:user, :admin_user]
  before_action :authenticate_logged_in!
  before_action :set_dpa_exception, only: [:show, :edit, :update, :archive]
  before_action :add_index_breadcrumb, only: [:index, :show, :new, :edit]

  def index
    @dpa_exceptions = DpaException.active
  end

  def show
    add_breadcrumb(@dpa_exception.third_party_product_service)
  end

  def edit
    add_breadcrumb(@dpa_exception.third_party_product_service, dpa_exception_path(@dpa_exception))
    add_breadcrumb('Edit')
  end

  def archive
    @dpa_exception = DpaException.find(params[:id])
    authorize @dpa_exception
    if @dpa_exception.archive
      respond_to do |format|
        format.html { redirect_to dpa_exceptions_path, notice: 'dpa exception record was successfully archived.' }
        format.json { head :no_content }
      end
    else
      format.html { redirect_to dpa_exceptions_path, alert: 'error archiving dpa exception record.' }
      format.json { head :no_content }
    end
  end
  
  def audit_log
    @dpa_exceptions = DpaException.all
  end

  private

    def set_dpa_exception
      @dpa_exception = DpaException.find(params[:id])
    end

    def add_index_breadcrumb
      add_breadcrumb(controller_name.titleize, dpa_exceptions_path)
    end

    def dpa_exception_params
      params.require(:dpa_exception).permit(:review_date_exception_first_approval_date, :third_party_product_service, :used_by, :point_of_contact, :review_findings, :review_summary, :lsa_security_recommendation, :lsa_security_determination, :lsa_security_approval, :lsa_technology_services_approval, :exception_approval_date_exception_renewal_date_due, :review_date_exception_review_date, :notes, :sla_agreement, :sla_attachment, :data_type_id, :incomplete, attachments: [])
    end

end
