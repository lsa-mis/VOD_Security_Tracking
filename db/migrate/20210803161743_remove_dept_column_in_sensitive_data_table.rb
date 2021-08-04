class RemoveDeptColumnInSensitiveDataTable < ActiveRecord::Migration[6.1]
  def change
    remove_column :sensitive_data_systems, :dept
  end
end
