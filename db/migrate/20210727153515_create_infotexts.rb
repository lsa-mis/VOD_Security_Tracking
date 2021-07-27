class CreateInfotexts < ActiveRecord::Migration[6.1]
  def change
    create_table :infotexts do |t|
      t.string :location, null: false

      t.timestamps
    end
  end
end
