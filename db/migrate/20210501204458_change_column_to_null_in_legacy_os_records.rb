class ChangeColumnToNullInLegacyOsRecords < ActiveRecord::Migration[6.1]
  def change
    change_column :legacy_os_records, :dept, :string, null: true
    change_column :legacy_os_records, :dept, :string, null: true
    change_column :legacy_os_records, :phone, :string, null: true
    change_column :legacy_os_records, :support_poc, :string, null: true
    change_column :legacy_os_records, :device_id, :bigint, null: true
    change_column :legacy_os_records, :unique_date, :datetime, null: true
  end
end
