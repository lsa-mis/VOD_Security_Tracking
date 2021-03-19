class CreateDataClassificationLevels < ActiveRecord::Migration[6.1]
  def change
    create_table :data_classification_levels do |t|
      t.string :name
      t.text :description

      t.timestamps
    end
  end
end
