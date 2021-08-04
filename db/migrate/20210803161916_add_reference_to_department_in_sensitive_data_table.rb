class AddReferenceToDepartmentInSensitiveDataTable < ActiveRecord::Migration[6.1]
  def change
    add_reference :sensitive_data_systems, :department, null: false, foreign_key: true
  end
end
