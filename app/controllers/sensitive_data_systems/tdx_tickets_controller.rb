class SensitiveDataSystems::TdxTicketsController < TdxTicketsController
    before_action :set_records_to_tdx

    private

    def set_records_to_tdx
        @records_to_tdx = SensitiveDataSystem.find(params[:sensitive_data_system_id])
    end

end