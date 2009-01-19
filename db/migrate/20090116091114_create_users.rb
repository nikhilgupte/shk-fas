class CreateUsers < ActiveRecord::Migration
  def self.up
    create_table :users do |t|
      t.string :username, :null => false, :limit => 10
      t.string :email_address, :null => false, :limit => 255
      t.string :password, :null => false, :limit => 50
      t.string :salt, :null => false, :limit => 8

      t.timestamps
    end
    execute %{create unique index index_users_on_username on users(lower(username))}
    execute %{create unique index index_users_on_email_address on users(lower(email_address))}
  end

  def self.down
    drop_table :users
  end
end
