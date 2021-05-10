class ChangeColumnNullInItSecurityIncident < ActiveRecord::Migration[6.1]
  def change
    change_column_null :it_security_incidents, :people_involved, false
    change_column_null :it_security_incidents, :equipment_involved, false
    change_column_null :it_security_incidents, :remediation_steps, false
  end
end
