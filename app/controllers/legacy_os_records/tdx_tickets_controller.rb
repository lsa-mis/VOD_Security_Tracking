class LegacyOsRecords::TdxTicketsController < TdxTicketsController
    before_action :set_record_to_tdx

    private

    def set_record_to_tdx
        @record_to_tdx = LegacyOsRecord.find(params[:legacy_os_record_id])
    end

end