class CreateLegacyOsRecords < ActiveRecord::Migration[6.1]
  def change
    create_table :legacy_os_records do |t|
      t.string :owner_username
      t.string :owner_full_name
      t.string :dept
      t.string :phone
      t.string :additional_dept_contact
      t.string :additional_dept_contact_phone
      t.string :support_poc
      t.string :legacy_os
      t.string :unique_app
      t.string :unique_hardware
      t.datetime :unique_date
      t.string :remediation
      t.datetime :exception_approval_date
      t.datetime :review_date
      t.string :review_contact
      t.string :justification
      t.string :local_it_support_group
      t.text :notes
      t.references :data_type, null: false, foreign_key: true
      t.references :device, null: false, foreign_key: true

      t.timestamps
    end
  end
end
