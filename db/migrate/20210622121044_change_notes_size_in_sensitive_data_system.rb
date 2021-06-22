class ChangeNotesSizeInSensitiveDataSystem < ActiveRecord::Migration[6.1]
  def change
    change_column :sensitive_data_systems, :notes, :text
  end
end
