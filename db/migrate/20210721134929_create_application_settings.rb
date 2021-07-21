class CreateApplicationSettings < ActiveRecord::Migration[6.1]
  def change
    create_table :application_settings do |t|
      t.string :page
      t.string :description
      t.text :index_description
      t.text :form_instruction

      t.timestamps
    end
  end
end
