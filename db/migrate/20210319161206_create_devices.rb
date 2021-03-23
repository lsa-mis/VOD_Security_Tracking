class CreateDevices < ActiveRecord::Migration[6.1]
  def change
    create_table :devices do |t|
      t.string :serial
      t.string :hostname
      t.string :mac
      t.string :building
      t.string :room

      t.timestamps
    end
  end
end
