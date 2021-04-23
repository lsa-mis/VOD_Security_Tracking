class RemoveTicketNumberFromTdxTicket < ActiveRecord::Migration[6.1]
  def change
    remove_column :tdx_tickets, :ticket_number, :integer
  end
end
