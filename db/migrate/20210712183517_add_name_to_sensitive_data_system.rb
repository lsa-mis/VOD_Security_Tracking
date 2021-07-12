class AddNameToSensitiveDataSystem < ActiveRecord::Migration[6.1]
  def change
    add_column :sensitive_data_systems, :name, :string, null: false
  end
end
