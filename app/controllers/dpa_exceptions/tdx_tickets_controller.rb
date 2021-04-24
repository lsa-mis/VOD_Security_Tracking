class DpaExceptions::TdxTicketsController < TdxTicketsController
    before_action :set_records_to_tdx

    private

    def set_records_to_tdx
        @records_to_tdx = DpaException.find(params[:dpa_exception_id])
    end

end