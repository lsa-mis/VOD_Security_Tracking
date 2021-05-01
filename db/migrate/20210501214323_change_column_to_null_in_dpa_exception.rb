class ChangeColumnToNullInDpaException < ActiveRecord::Migration[6.1]
  def change
    change_column :dpa_exceptions, :review_date_exception_first_approval_date, :datetime, null: true
    change_column :dpa_exceptions, :used_by, :string, null: true
    change_column :dpa_exceptions, :lsa_security_approval, :string, null: true
    change_column :dpa_exceptions, :lsa_technology_services_approval, :string, null: true
    change_column :dpa_exceptions, :exception_approval_date_exception_renewal_date_due, :datetime, null: true
    change_column :dpa_exceptions, :review_date_exception_review_date, :datetime, null: true

  end
end
