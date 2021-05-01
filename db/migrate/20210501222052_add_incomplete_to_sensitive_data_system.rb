class AddIncompleteToSensitiveDataSystem < ActiveRecord::Migration[6.1]
  def change
    add_column :sensitive_data_systems, :incomplete, :boolean, default: false
  end
end
