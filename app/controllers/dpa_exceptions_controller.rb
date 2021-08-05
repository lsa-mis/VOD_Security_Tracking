class DpaExceptionsController < InheritedResources::Base

  before_action :verify_duo_authentication
  devise_group :logged_in, contains: [:user, :admin_user]
  before_action :authenticate_logged_in!
  before_action :set_dpa_exception, only: [:show, :edit, :update, :archive, :audit_log]
  before_action :add_index_breadcrumb, only: [:index, :show, :new, :edit, :audit_log]
  before_action :set_form_infotext, only: [:new, :edit]
  before_action :set_number_of_items, only: [:index, :audit_log]

  def index
    
    @dpa_exception_index_text = Infotext.find_by(location: "dpa_exception_index")
    
    if params[:q].nil?
      @q = DpaException.active.ransack(params[:q])
    else
      if params[:q][:data_type_id_blank].present? && params[:q][:data_type_id_blank] == "0"
        params[:q] = params[:q].except("data_type_id_blank")
      end
      if params[:q][:incomplete_true].present? && params[:q][:incomplete_true] == "0"
        params[:q] = params[:q].except("incomplete_true")
      end
      @q = DpaException.active.ransack(params[:q].try(:merge, m: params[:q][:m]))
    end
    @q.sorts = ["created_at desc"] if @q.sorts.empty?

    if session[:items].present?
      @pagy, @dpa_exceptions = pagy(@q.result, items: session[:items])
    else
      @pagy, @dpa_exceptions = pagy(@q.result)
    end

    @dpa_status = DpaExceptionStatus.where(id: DpaException.pluck(:dpa_exception_status_id).uniq)
    @used_by = @dpa_exceptions.pluck(:used_by).uniq
    @data_type = DataType.where(id: DpaException.pluck(:data_type_id).uniq)
    
    authorize @dpa_exceptions
    # Rendering code will go here
    if params[:format] == "csv"
      respond_to do |format|
        format.html
        format.csv { send_data @dpa_exceptions.to_csv, filename: "DPA Exceptions-#{Date.today}.csv"}
      end
    else
      unless params[:q].nil?
        render turbo_stream: turbo_stream.replace(
        :dpa_exceptionListing,
        partial: "dpa_exceptions/listing"
      )
      end

    end


    
  end

  def show
    add_breadcrumb(@dpa_exception.display_name)
    authorize @dpa_exception
  end

  def new
    @dpa_exception = DpaException.new
    authorize @dpa_exception
  end

  def create 
    @dpa_exception = DpaException.new(dpa_exception_params.except(:tdx_ticket))
    if dpa_exception_params[:tdx_ticket][:ticket_link].present?
      @dpa_exception.tdx_tickets.new(
          ticket_link: dpa_exception_params[:tdx_ticket][:ticket_link]
        )
    end
    respond_to do |format|
      if @dpa_exception.save 
        format.turbo_stream { redirect_to dpa_exception_path(@dpa_exception), 
          notice: 'DPA Exception record was successfully created.' 
        }
      else
        # Rails.logger.info(@dpa_exception.errors.inspect)
        format.turbo_stream
      end
    end
  end

  def edit
    add_breadcrumb(@dpa_exception.display_name, 
                    dpa_exception_path(@dpa_exception)
                  )
    add_breadcrumb('Edit')
    @tdx_ticket = @dpa_exception.tdx_tickets.new
    authorize @dpa_exception
  end

  def update
    if dpa_exception_params[:tdx_ticket][:ticket_link].present?
      @dpa_exception.tdx_tickets.create(
          ticket_link: dpa_exception_params[:tdx_ticket][:ticket_link]
        )
    end
    respond_to do |format|
      if @dpa_exception.update(dpa_exception_params.except(:tdx_ticket))
        format.turbo_stream { redirect_to @dpa_exception, notice: 'DPA Exception record was successfully updated. ' }
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
                      notice: 'DPA Exception record was successfully archived.' 
                    }
      else
        Rails.logger.info(@dpa_exception.errors.inspect) 
        format.turbo_stream { redirect_to dpa_exceptions_path, 
                      alert: 'Error archiving DPA Exception record.' 
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

    if session[:items].present?
      @pagy, @dpa_exception_audit_log = pagy(@dpa_exception.audits.all.reorder(created_at: :desc), items: session[:items])
    else
      @pagy, @dpa_exception_audit_log = pagy(@dpa_exception.audits.all.reorder(created_at: :desc))
    end
  end

  private
  
    def set_dpa_exception
      @dpa_exception = DpaException.find(params[:id])
    end

    def add_index_breadcrumb
      # add_breadcrumb(controller_name.titleize, dpa_exceptions_path)
      add_breadcrumb("DPA Exceptions", dpa_exceptions_path)
    end

    def set_form_infotext
      @dpa_exception_form_text = Infotext.find_by(location: "dpa_exception_form")
    end

    def set_number_of_items
      if params[:items].present?
        session[:items] = params[:items]
      end
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
                    :sla_attachment, :data_type_id, :incomplete, :m,
                    :dpa_exception_status_id, :format,
                    attachments: [], tdx_ticket: [:ticket_link]
                  )
    end

end
