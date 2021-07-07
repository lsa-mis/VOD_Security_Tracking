class ChangeFieldNameInItSecurityIncident < ActiveRecord::Migration[6.1]
  def change
    rename_column :it_security_incidents, :estimated_finacial_cost, :estimated_financial_cost
  end
end
