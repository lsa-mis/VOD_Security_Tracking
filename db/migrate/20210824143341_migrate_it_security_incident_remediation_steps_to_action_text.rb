class MigrateItSecurityIncidentRemediationStepsToActionText < ActiveRecord::Migration[6.1]
  include ActionView::Helpers::TextHelper
  def change
    rename_column :it_security_incidents, :remediation_steps, :remediation_steps_old
    ItSecurityIncident.all.each do |its|
      its.update_attribute(:remediation_steps, simple_format(its.remediation_steps_old))
    end
    remove_column :it_security_incidents, :remediation_steps_old
  end
end
