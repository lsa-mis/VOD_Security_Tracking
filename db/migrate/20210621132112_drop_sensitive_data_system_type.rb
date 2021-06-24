class DropSensitiveDataSystemType < ActiveRecord::Migration[6.1]
  def change
    remove_reference :sensitive_data_systems, :sensitive_data_system_type, index: true, foreign_key: true
    drop_table :sensitive_data_system_types
  end
end
