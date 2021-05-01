class ChangeNullColumnsInSensitiveDataSystem < ActiveRecord::Migration[6.1]
  def change
    change_column :sensitive_data_systems, :owner_full_name, :string, null: false
    change_column :sensitive_data_systems, :support_poc, :string, null: true
  end
end
