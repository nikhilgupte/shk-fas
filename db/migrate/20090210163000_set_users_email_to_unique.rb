class SetUsersEmailToUnique < ActiveRecord::Migration
  def self.up
    change_column :users, :email_address, :string, :null => false
    change_column :users, :full_name, :string, :null => false
    execute %{create unique index index_users_on_email_address on users(lower(email_address))}
  end

  def self.down
  end
end
