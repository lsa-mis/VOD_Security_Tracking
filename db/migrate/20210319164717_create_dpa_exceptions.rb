class CreateDpaExceptions < ActiveRecord::Migration[6.1]
  def change
    create_table :dpa_exceptions do |t|
      t.datetime :review_date
      t.text :third_party_product_service
      t.string :used_by
      t.string :point_of_contact
      t.text :review_findings
      t.text :review_summary
      t.text :lsa_security_recommendation
      t.text :lsa_security_determination
      t.string :lsa_security_approval
      t.string :lsa_technology_services_approval
      t.datetime :exception_approval_date
      t.string :notes
      t.string :tdx_ticket
      t.string :sla_agreement
      t.references :data_type, null: false, foreign_key: true

      t.timestamps
    end
  end
end
