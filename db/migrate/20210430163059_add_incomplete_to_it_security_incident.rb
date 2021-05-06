class AddIncompleteToItSecurityIncident < ActiveRecord::Migration[6.1]
  def change
    add_column :it_security_incidents, :incomplete, :boolean, default: false
  end
end
