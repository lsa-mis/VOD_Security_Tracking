class AddTicketLinkToTdxTicket < ActiveRecord::Migration[6.1]
  def change
    add_column :tdx_tickets, :ticket_link, :string
  end
end
