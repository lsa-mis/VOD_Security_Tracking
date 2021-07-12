class RemoveDpaStatusColumnFromDpaExceptionTable < ActiveRecord::Migration[6.1]
  def change
    remove_column :dpa_exceptions, :dpa_status
  end
end
