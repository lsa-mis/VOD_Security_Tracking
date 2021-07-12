class AddReferenceToDpaExceptionsStatus < ActiveRecord::Migration[6.1]
  def change
    add_reference :dpa_exceptions, :dpa_exception_status, null: false, foreign_key: true
  end
end
