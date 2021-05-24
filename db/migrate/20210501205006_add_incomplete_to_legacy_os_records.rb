class AddIncompleteToLegacyOsRecords < ActiveRecord::Migration[6.1]
  def change
    add_column :legacy_os_records, :incomplete, :boolean, default: false
  end
end
