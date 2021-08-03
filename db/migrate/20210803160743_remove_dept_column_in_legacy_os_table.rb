class RemoveDeptColumnInLegacyOsTable < ActiveRecord::Migration[6.1]
  def change
    remove_column :legacy_os_records, :dept
  end
end
