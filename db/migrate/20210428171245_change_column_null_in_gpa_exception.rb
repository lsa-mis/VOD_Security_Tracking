class ChangeColumnNullInGpaException < ActiveRecord::Migration[6.1]
  def change
    change_column_null :dpa_exceptions, :review_date, false
    change_column_null :dpa_exceptions, :third_party_product_service, false
    change_column_null :dpa_exceptions, :used_by, false
    change_column_null :dpa_exceptions, :lsa_security_approval, false
    change_column_null :dpa_exceptions, :lsa_technology_services_approval, false
    change_column_null :dpa_exceptions, :exception_approval_date, false
  end
end
