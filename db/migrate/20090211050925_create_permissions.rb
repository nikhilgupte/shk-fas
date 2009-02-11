class CreatePermissions < ActiveRecord::Migration
  extend MigrationHelpers
  def self.up
    create_table :permissions do |t|
      t.integer :user_id, :null => false
      t.string :module, :null => false
      t.string :operation, :null => false
    end
    add_index :permissions, [:user_id, :module, :operation], :unique => true
    foreign_key(:permissions, :user_id, :users, true)
  end

  def self.down
    drop_table :permissions
  end
end
