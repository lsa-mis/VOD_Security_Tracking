class DpaExceptionsController < InheritedResources::Base

  private

    def dpa_exception_params
      params.require(:dpa_exception).permit(:review_date, :third_party_product_service, :used_by, :point_of_contact, :review_findings, :review_summary, :lsa_security_recommendation, :lsa_security_determination, :lsa_security_approval, :lsa_technology_services_approval, :exception_approval_date, :notes, :sla_agreement, :sla_attachment, :data_type_id, attachments: [])
    end

end
