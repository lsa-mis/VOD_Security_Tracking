class RemoveTdxTicketFromDpaException < ActiveRecord::Migration[6.1]
  def change
    remove_column :dpa_exceptions, :tdx_ticket, :string
  end
end
