class AddFieldsToOrders < ActiveRecord::Migration
  def self.up
    add_column :orders, :submitted_at, :datetime
    add_column :orders, :location, :string, :limit => 1
    add_column :orders, :priority, :string, :limit => 1
    add_column :orders, :production_quantity, :float
  end

  def self.down
    remove_column :orders, :submitted_at
    remove_column :orders, :location
    remove_column :orders, :priority
    remove_column :orders, :production_quantity
  end
end
