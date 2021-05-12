class AddSensitiveDataSystemTypesToSensitiveDataSystems < ActiveRecord::Migration[6.1]
  def change
    add_reference :sensitive_data_systems, :sensitive_data_system_type, null: false, foreign_key: true
  end
end
