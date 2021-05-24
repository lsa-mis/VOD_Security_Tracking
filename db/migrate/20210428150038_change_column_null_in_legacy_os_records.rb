class ChangeColumnNullInLegacyOsRecords < ActiveRecord::Migration[6.1]
  def change
    change_column_null :legacy_os_records, :owner_username, false
    change_column_null :legacy_os_records, :owner_full_name, false
    change_column_null :legacy_os_records, :dept, false
    change_column_null :legacy_os_records, :support_poc, false
    change_column_null :legacy_os_records, :legacy_os, false
    change_column_null :legacy_os_records, :unique_date, false
    change_column_null :legacy_os_records, :remediation, false
    change_column_null :legacy_os_records, :review_contact, false
  end
end
