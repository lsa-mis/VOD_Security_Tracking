class AddColumnToDpaException < ActiveRecord::Migration[6.1]
  def change
    add_column :dpa_exceptions, :review_date_exception_review_date, :DateTime
  end
end
