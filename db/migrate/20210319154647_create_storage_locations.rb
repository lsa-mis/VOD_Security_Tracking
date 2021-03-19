class CreateStorageLocations < ActiveRecord::Migration[6.1]
  def change
    create_table :storage_locations do |t|
      t.string :name
      t.string :description
      t.string :description_link

      t.timestamps
    end
  end
end
