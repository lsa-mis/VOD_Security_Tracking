class ChangeDeviceIdToNullInSensitiveDataSystem < ActiveRecord::Migration[6.1]
  def change
    change_column :sensitive_data_systems, :device_id, :bigint, null: true
  end
end
