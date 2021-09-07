class CreateNotifications < ActiveRecord::Migration[6.1]
  def change
    create_table :notifications do |t|
      t.string :note
      t.datetime :opendate
      t.datetime :closedate
      t.string :notetype

      t.timestamps
    end
  end
end
