class CreateUsers < ActiveRecord::Migration
  def self.up
    create_table :users do |t|
      t.string :username, :null => false, :limit => 10
      t.string :password, :null => false, :limit => 50
      t.string :salt, :null => false, :limit => 8

      t.timestamps
    end
    execute %{create unique index index_users_on_username on users(lower(username))}
  end

  def self.down
    drop_table :users
  end
end
