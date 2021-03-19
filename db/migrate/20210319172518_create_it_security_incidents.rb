class CreateItSecurityIncidents < ActiveRecord::Migration[6.1]
  def change
    create_table :it_security_incidents do |t|
      t.datetime :date
      t.text :people_involved
      t.text :equipment_involved
      t.text :remediation_steps
      t.integer :estimated_finacial_cost
      t.text :notes
      t.references :it_security_incident_status, null: false, foreign_key: true
      t.references :data_type, null: false, foreign_key: true

      t.timestamps
    end
  end
end
