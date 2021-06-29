class AddDpaStatusToDpaExceptions < ActiveRecord::Migration[6.1]
  def change
    add_column :dpa_exceptions, :dpa_status, :integer, default: 0, null: false
  end
end
