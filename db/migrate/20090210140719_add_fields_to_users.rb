class AddFieldsToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :full_name, :string
    add_column :users, :email_address, :string
    add_column :users, :last_logged_in_at, :datetime
    add_column :users, :access_level, :integer, :default => 0, :null => false
  end

  def self.down
    remove_column :users, :full_name
    remove_column :users, :email_address
    remove_column :users, :last_logged_in_at
    remove_column :users, :access_level
  end
end
