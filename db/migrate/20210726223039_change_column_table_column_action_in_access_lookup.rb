class ChangeColumnTableColumnActionInAccessLookup < ActiveRecord::Migration[6.1]
  def change
    rename_column :access_lookups, :table, :vod_table
    rename_column :access_lookups, :action, :vod_action
  end
end
