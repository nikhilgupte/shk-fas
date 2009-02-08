class CreateOrders < ActiveRecord::Migration
  def self.up
    create_table :orders do |t|
      t.integer :product_id, :null => false
      t.float :quantity, :null => false
      t.float :production_quantity, :null => false
      t.integer :created_by_id, :null => false
      t.string :location, :limit => 1
      t.string :priority, :limit => 1
      t.datetime :submitted_at, :datetime

      t.timestamps
    end
    add_index :orders, :product_id
    add_index :orders, :created_by_id
  end

  def self.down
    drop_table :orders
  end
end
