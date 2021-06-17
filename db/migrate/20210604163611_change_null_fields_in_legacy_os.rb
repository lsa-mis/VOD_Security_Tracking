class ChangeNullFieldsInLegacyOs < ActiveRecord::Migration[6.1]
  def change
    change_column :legacy_os_records, :legacy_os, :string, null: true
    change_column :legacy_os_records, :remediation, :string, null: true
    change_column :legacy_os_records, :review_contact, :string, null: true
    change_column :legacy_os_records, :data_type_id, :bigint, null: true
  end
end
