class OldMigrations < ActiveRecord::Migration[6.1]
  REQUIRED_VERSION = 20210817173118
  def up
    if ActiveRecord::Migrator.current_version < REQUIRED_VERSION
      raise StandardError, "`rails db:schema:load` must be run prior to `rails db:migrate`"
    end
  end
end