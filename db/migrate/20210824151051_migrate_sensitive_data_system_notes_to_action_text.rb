class MigrateSensitiveDataSystemNotesToActionText < ActiveRecord::Migration[6.1]
  include ActionView::Helpers::TextHelper
  def change
    rename_column :sensitive_data_systems, :notes, :notes_old
    SensitiveDataSystem.all.each do |sds|
      sds.update_attribute(:notes, simple_format(sds.notes_old))
    end
    remove_column :sensitive_data_systems, :notes_old
  end
end
