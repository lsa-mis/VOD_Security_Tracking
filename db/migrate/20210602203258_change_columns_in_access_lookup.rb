class ChangeColumnsInAccessLookup < ActiveRecord::Migration[6.1]
  def change
    remove_column :access_lookups, :table
    add_column :access_lookups, :table, :integer, default: 0, null: false
    remove_column :access_lookups, :action
    add_column :access_lookups, :action, :integer, default: 0, null: false
  end
end
