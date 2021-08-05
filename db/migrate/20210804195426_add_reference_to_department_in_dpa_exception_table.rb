class AddReferenceToDepartmentInDpaExceptionTable < ActiveRecord::Migration[6.1]
  def change
    add_reference :dpa_exceptions, :department, null: false, foreign_key: true
  end
end
