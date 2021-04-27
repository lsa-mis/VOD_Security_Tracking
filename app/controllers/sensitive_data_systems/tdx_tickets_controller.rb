class SensitiveDataSystems::TdxTicketsController < TdxTicketsController
    before_action :set_record_to_tdx

    private

    def set_record_to_tdx
        @record_to_tdx = SensitiveDataSystem.find(params[:sensitive_data_system_id])
    end

end