class MigrateLegacyOsRecordRemediationToActionText < ActiveRecord::Migration[6.1]
  include ActionView::Helpers::TextHelper
  def change
    rename_column :legacy_os_records, :remediation, :remediation_old
    LegacyOsRecord.all.each do |lor|
      lor.update_attribute(:remediation, simple_format(lor.remediation_old))
    end
    remove_column :legacy_os_records, :remediation_old
  end
end
