class ChangeColumnToNulOnItSecurityIncident < ActiveRecord::Migration[6.1]
  def change
    change_column :it_security_incidents, :it_security_incident_status_id, :bigint, null: true

  end
end
