class CreateOrders < ActiveRecord::Migration
  def self.up
    create_table :orders do |t|
      t.integer :product_id, :null => false
      t.float :quantity, :null => false
      t.integer :created_by_id, :null => false

      t.timestamps
    end
    add_index :orders, :product_id
    add_index :orders, :creator_id
  end

  def self.down
    drop_table :orders
  end
end
