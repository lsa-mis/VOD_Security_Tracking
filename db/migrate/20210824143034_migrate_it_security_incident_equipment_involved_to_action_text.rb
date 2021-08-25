class MigrateItSecurityIncidentEquipmentInvolvedToActionText < ActiveRecord::Migration[6.1]
  include ActionView::Helpers::TextHelper
  def change
    rename_column :it_security_incidents, :equipment_involved, :equipment_involved_old
    ItSecurityIncident.all.each do |its|
      its.update_attribute(:equipment_involved, simple_format(its.equipment_involved_old))
    end
    remove_column :it_security_incidents, :equipment_involved_old
  end
end
