class ChangeNotesSizeInDpaException < ActiveRecord::Migration[6.1]
  def change
    change_column :dpa_exceptions, :notes, :text
  end
end
