class MigrateItSecurityIncidentPeopleInvolvedToActionText < ActiveRecord::Migration[6.1]
  include ActionView::Helpers::TextHelper
  def change
    rename_column :it_security_incidents, :people_involved, :people_involved_old
    ItSecurityIncident.all.each do |its|
      its.update_attribute(:people_involved, simple_format(its.people_involved_old))
    end
    remove_column :it_security_incidents, :people_involved_old
  end
end
