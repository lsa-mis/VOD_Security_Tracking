class CreateAccessLookups < ActiveRecord::Migration[6.1]
  def change
    create_table :access_lookups do |t|
      t.string :ldap_group
      t.string :table
      t.string :action

      t.timestamps
    end
  end
end
