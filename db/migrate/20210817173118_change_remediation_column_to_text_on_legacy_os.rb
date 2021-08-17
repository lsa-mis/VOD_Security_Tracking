class ChangeRemediationColumnToTextOnLegacyOs < ActiveRecord::Migration[6.1]
  def change
    change_column :legacy_os_records, :remediation, :text
    change_column :legacy_os_records, :justification, :text
  end
end
