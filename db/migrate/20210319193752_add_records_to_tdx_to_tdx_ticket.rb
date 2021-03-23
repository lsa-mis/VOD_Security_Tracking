class AddRecordsToTdxToTdxTicket < ActiveRecord::Migration[6.1]
  def change
    add_reference :tdx_tickets, :records_to_tdx, polymorphic: true, null: false
  end
end
