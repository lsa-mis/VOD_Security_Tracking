class DpaExceptionsController < InheritedResources::Base
  before_action :set_tickets_destroy_path

  def destroy
    @dpa_exception = DpaException.find(params[:id])
    authorize @dpa_exception
    
    if @dpa_exception.destroy
      flash[:notice] = "\"#{@dpa_exception.id}\" was successfully deleted."
      redirect_to @dpa_exception
    else
      flash.now[:alert] = "There was an error deleting the dpa_exception."
      render :show
    end
  end 
  
  def audit_log
    @dpa_exceptions = DpaException.all
  end

  private

    def set_tickets_destroy_path
      @tickets_destroy_path = 'dpa_exception_tdx_ticket_path(params[:id],tdx.id)'
    end

    def dpa_exception_params
      params.require(:dpa_exception).permit(:review_date, :third_party_product_service, :used_by, :point_of_contact, :review_findings, :review_summary, :lsa_security_recommendation, :lsa_security_determination, :lsa_security_approval, :lsa_technology_services_approval, :exception_approval_date, :notes, :sla_agreement, :sla_attachment, :data_type_id, attachments: [])
    end

end
