class AddIncompleteToDpaExceptions < ActiveRecord::Migration[6.1]
  def change
    add_column :dpa_exceptions, :incomplete, :boolean, default: false
  end
end
