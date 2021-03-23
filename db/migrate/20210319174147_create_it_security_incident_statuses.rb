class CreateItSecurityIncidentStatuses < ActiveRecord::Migration[6.1]
  def change
    create_table :it_security_incident_statuses do |t|
      t.string :name
      t.string :description

      t.timestamps
    end
  end
end
