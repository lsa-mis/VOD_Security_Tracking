class MigrateLegacyOsRecordNotesToActionText < ActiveRecord::Migration[6.1]
  include ActionView::Helpers::TextHelper
  def change
    rename_column :legacy_os_records, :notes, :notes_old
    LegacyOsRecord.all.each do |lor|
      lor.update_attribute(:notes, simple_format(lor.notes_old))
    end
    remove_column :legacy_os_records, :notes_old
  end
end
