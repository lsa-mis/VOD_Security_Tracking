class AddCheckboxToStorageLocation < ActiveRecord::Migration[6.1]
  def change
    add_column :storage_locations, :device_is_required, :boolean, default: false
  end
end
