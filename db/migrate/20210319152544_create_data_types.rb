class CreateDataTypes < ActiveRecord::Migration[6.1]
  def change
    create_table :data_types do |t|
      t.string :name
      t.string :description
      t.string :description_link
      t.references :data_classification_level, null: false, foreign_key: true

      t.timestamps
    end
  end
end
