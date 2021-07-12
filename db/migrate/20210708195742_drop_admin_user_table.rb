class DropAdminUserTable < ActiveRecord::Migration[6.1]
  def up
    drop_table :admin_users
  end

  def down
    fail ActiveRecord::IrreversibleMigration
  end
end
