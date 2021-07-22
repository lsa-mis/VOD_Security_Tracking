class CreateApplicationSettings < ActiveRecord::Migration[6.1]
  def change
    create_table :application_settings do |t|
      t.string :title

      t.timestamps
    end
  end
end
