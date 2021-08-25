class MigrateItSecurityIncidentNotesToActionText < ActiveRecord::Migration[6.1]
  include ActionView::Helpers::TextHelper
  def change
    rename_column :it_security_incidents, :notes, :notes_old
    ItSecurityIncident.all.each do |its|
      its.update_attribute(:notes, simple_format(its.notes_old))
    end
    remove_column :it_security_incidents, :notes_old
  end
end
