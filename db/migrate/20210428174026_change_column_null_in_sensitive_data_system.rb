class ChangeColumnNullInSensitiveDataSystem < ActiveRecord::Migration[6.1]
  def change
    change_column_null :sensitive_data_systems, :owner_username, false
    change_column_null :sensitive_data_systems, :support_poc, false
    change_column_null :sensitive_data_systems, :review_date, false
    change_column_null :sensitive_data_systems, :review_contact, false
  end
end
