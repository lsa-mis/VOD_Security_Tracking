class RemoveUsedByColumnInDpaExceptionTable < ActiveRecord::Migration[6.1]
  def change
    remove_column :dpa_exceptions, :used_by
  end
end
