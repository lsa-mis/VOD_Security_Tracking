class DpaExceptionsController < InheritedResources::Base

  devise_group :logged_in, contains: [:user, :admin_user]
  before_action :authenticate_logged_in!
  before_action :set_dpa_exception, only: [:show, :edit, :update, :archive, :audit_log]
  before_action :add_index_breadcrumb, only: [:index, :show, :new, :edit, :audit_log]
  before_action :set_membership

  def index
    @dpa_exceptions = DpaException.active
    authorize @dpa_exceptions
  end

  def show
    add_breadcrumb(@dpa_exception.third_party_product_service)
    authorize @dpa_exception
  end

  def new
    @dpa_exception = DpaException.new
    authorize @dpa_exception
  end

  def create 
    @dpa_exception = DpaException.new(dpa_exception_params.except(:tdx_ticket))
    if dpa_exception_params[:tdx_ticket][:ticket_link].present?
      @dpa_exception.tdx_tickets.new(ticket_link: dpa_exception_params[:tdx_ticket][:ticket_link])
    end
    respond_to do |format|
      if @dpa_exception.save 
        format.turbo_stream { redirect_to dpa_exception_path(@dpa_exception), 
          notice: 'dpa exception record was successfully created. ' 
        }
      else
        Rails.logger.info(@dpa_exception.errors.inspect)
        format.turbo_stream
      end
    end
  end

  def edit
    add_breadcrumb(@dpa_exception.third_party_product_service, 
                    dpa_exception_path(@dpa_exception)
                  )
    add_breadcrumb('Edit')
    @tdx_ticket = @dpa_exception.tdx_tickets.new
    authorize @dpa_exception
  end

  def update
    if dpa_exception_params[:tdx_ticket][:ticket_link].present?
      @dpa_exception.tdx_tickets.create(ticket_link: dpa_exception_params[:tdx_ticket][:ticket_link])
    end
    respond_to do |format|
      if @dpa_exception.update(dpa_exception_params.except(:tdx_ticket))
        format.turbo_stream { redirect_to @dpa_exception, notice: 'dpa exception record was successfully updated. ' }
      else
        format.turbo_stream
      end
    end
  end

  def archive
    authorize @dpa_exception
    respond_to do |format|
      if @dpa_exception.archive
        format.turbo_stream { redirect_to dpa_exceptions_path, 
                      notice: 'dpa exception record was successfully archived.' 
                    }
      else
        Rails.logger.info(@dpa_exception.errors.inspect) 
        format.turbo_stream { redirect_to dpa_exceptions_path, 
                      alert: 'error archiving dpa exception record.' 
                    }
      end
    end
  end

  def audit_log
    authorize @dpa_exception
    add_breadcrumb(@dpa_exception.third_party_product_service, 
      dpa_exception_path(@dpa_exception)
                  )
    add_breadcrumb('Audit')

    @dpa_item_audit_log = @dpa_exception.audits.all.reorder(created_at: :desc)
  end

  def delete_file_attachment
    @delete_file = ActiveStorage::Attachment.find(params[:id])
    @delete_file.purge
    redirect_back(fallback_location: request.referer)
  end

  private
  
    def set_membership
      current_user.membership = session[:user_memberships]
      # logger.debug "************ in DPA_EXCEPTION current_user.membership ***** #{current_user.membership}"
    end

    def set_dpa_exception
      @dpa_exception = DpaException.find(params[:id])
    end

    def add_index_breadcrumb
      add_breadcrumb(controller_name.titleize, dpa_exceptions_path)
    end

    def dpa_exception_params
      params.require(:dpa_exception).permit(
                    :review_date_exception_first_approval_date, 
                    :third_party_product_service, :used_by, 
                    :point_of_contact, :review_findings, :review_summary, 
                    :lsa_security_recommendation, :lsa_security_determination, 
                    :lsa_security_approval, :lsa_technology_services_approval, 
                    :exception_approval_date_exception_renewal_date_due, 
                    :review_date_exception_review_date, :notes, :sla_agreement,
                    :sla_attachment, :data_type_id, :incomplete,
                    attachments: [], tdx_ticket: [:ticket_link]
                  )
    end

end
