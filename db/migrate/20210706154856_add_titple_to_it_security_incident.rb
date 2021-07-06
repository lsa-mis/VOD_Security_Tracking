class AddTitpleToItSecurityIncident < ActiveRecord::Migration[6.1]
  def change
    add_column :it_security_incidents, :title, :string, null: false
  end
end
