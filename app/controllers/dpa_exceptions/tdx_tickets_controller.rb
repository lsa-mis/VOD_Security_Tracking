class DpaExceptions::TdxTicketsController < TdxTicketsController
    before_action :set_record_to_tdx

    private

    def set_record_to_tdx
        @record_to_tdx = DpaException.find(params[:dpa_exception_id])
    end

end