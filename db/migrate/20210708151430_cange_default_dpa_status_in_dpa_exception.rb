class CangeDefaultDpaStatusInDpaException < ActiveRecord::Migration[6.1]
  def change
    change_column :dpa_exceptions, :dpa_status, :string, default: :in_process
  end
end
