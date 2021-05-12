class CreateSensitiveDataSystemTypes < ActiveRecord::Migration[6.1]
  def change
    create_table :sensitive_data_system_types do |t|
      t.string :name
      t.string :description

      t.timestamps
    end
  end
end
