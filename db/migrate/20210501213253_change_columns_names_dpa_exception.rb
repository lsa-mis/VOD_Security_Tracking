class ChangeColumnsNamesDpaException < ActiveRecord::Migration[6.1]
  def change
    rename_column :dpa_exceptions, :review_date, :review_date_exception_first_approval_date
    rename_column :dpa_exceptions, :exception_approval_date, :exception_approval_date_exception_renewal_date_due
  end
end
