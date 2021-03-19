class CreateTdxTickets < ActiveRecord::Migration[6.1]
  def change
    create_table :tdx_tickets do |t|
      t.integer :ticket_number

      t.timestamps
    end
  end
end
