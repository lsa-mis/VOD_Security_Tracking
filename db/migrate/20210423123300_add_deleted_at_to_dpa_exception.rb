class AddDeletedAtToDpaException < ActiveRecord::Migration[6.1]
  def change
    add_column :dpa_exceptions, :deleted_at, :datetime
    add_column :it_security_incidents, :deleted_at, :datetime
    add_column :legacy_os_records, :deleted_at, :datetime
    add_column :sensitive_data_systems, :deleted_at, :datetime
  end
end
