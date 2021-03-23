class CreateSensitiveDataSystems < ActiveRecord::Migration[6.1]
  def change
    create_table :sensitive_data_systems do |t|
      t.string :owner_username
      t.string :owner_full_name
      t.string :dept
      t.string :phone
      t.string :additional_dept_contact
      t.string :additional_dept_contact_phone
      t.string :support_poc
      t.text :expected_duration_of_data_retention
      t.string :agreements_related_to_data_types
      t.datetime :review_date
      t.string :review_contact
      t.string :notes
      t.references :storage_location, null: false, foreign_key: true
      t.references :data_type, null: false, foreign_key: true
      t.references :device, null: false, foreign_key: true

      t.timestamps
    end
  end
end
