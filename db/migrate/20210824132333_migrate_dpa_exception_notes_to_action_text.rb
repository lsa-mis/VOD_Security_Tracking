class MigrateDpaExceptionNotesToActionText < ActiveRecord::Migration[6.1]
  include ActionView::Helpers::TextHelper
  def change
    rename_column :dpa_exceptions, :notes, :notes_old
    DpaException.all.each do |dpa|
      dpa.update_attribute(:notes, simple_format(dpa.notes_old))
    end
    remove_column :dpa_exceptions, :notes_old
  end
end
