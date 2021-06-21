class NullStorageLocationInSensitiveDataSystems < ActiveRecord::Migration[6.1]
  def change
    change_column :sensitive_data_systems, :storage_location_id, :bigint, null: true
  end
end
