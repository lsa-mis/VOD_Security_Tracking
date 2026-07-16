class CreateCommentsAndMigrateActiveAdminComments < ActiveRecord::Migration[7.2]
  def up
    create_table :comments do |t|
      t.string :namespace, default: "admin"
      t.text :body
      t.string :resource_type
      t.bigint :resource_id
      t.string :author_type
      t.bigint :author_id
      t.timestamps
    end

    add_index :comments, %i[author_type author_id]
    add_index :comments, %i[resource_type resource_id]
    add_index :comments, :namespace

    if table_exists?(:active_admin_comments)
      execute <<~SQL.squish
        INSERT INTO comments (namespace, body, resource_type, resource_id, author_type, author_id, created_at, updated_at)
        SELECT namespace, body, resource_type, resource_id, author_type, author_id, created_at, updated_at
        FROM active_admin_comments
      SQL
      drop_table :active_admin_comments
    end
  end

  def down
    create_table :active_admin_comments do |t|
      t.string :namespace
      t.text :body
      t.string :resource_type
      t.bigint :resource_id
      t.string :author_type
      t.bigint :author_id
      t.timestamps
    end

    add_index :active_admin_comments, %i[author_type author_id], name: "index_active_admin_comments_on_author"
    add_index :active_admin_comments, :namespace
    add_index :active_admin_comments, %i[resource_type resource_id], name: "index_active_admin_comments_on_resource"

    execute <<~SQL.squish
      INSERT INTO active_admin_comments (namespace, body, resource_type, resource_id, author_type, author_id, created_at, updated_at)
      SELECT namespace, body, resource_type, resource_id, author_type, author_id, created_at, updated_at
      FROM comments
    SQL

    drop_table :comments
  end
end
