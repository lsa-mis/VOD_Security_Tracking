class LegacyOsRecords::TdxTicketsController < TdxTicketsController
    before_action :set_records_to_tdx

    private

    def set_records_to_tdx
        @records_to_tdx = LegacyOsRecord.find(params[:legacy_os_record_id])
    end

end