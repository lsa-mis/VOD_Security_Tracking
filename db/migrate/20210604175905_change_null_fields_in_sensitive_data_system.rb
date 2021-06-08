class ChangeNullFieldsInSensitiveDataSystem < ActiveRecord::Migration[6.1]
  def change
    change_column :sensitive_data_systems, :data_type_id, :bigint, null: true
  end
end
