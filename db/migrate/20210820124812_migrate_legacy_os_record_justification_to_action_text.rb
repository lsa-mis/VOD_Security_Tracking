class MigrateLegacyOsRecordJustificationToActionText < ActiveRecord::Migration[6.1]
  include ActionView::Helpers::TextHelper
  def change
    rename_column :legacy_os_records, :justification, :justification_old
    LegacyOsRecord.all.each do |lor|
      lor.update_attribute(:justification, simple_format(lor.justification_old))
    end
    remove_column :legacy_os_records, :justification_old
  end
end
