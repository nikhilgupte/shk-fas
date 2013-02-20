class DropProductsQuarterlySalesQuantity < ActiveRecord::Migration
  def self.up
    remove_column :products, :quarterly_sales_quantity
  end

  def self.down
    add_column :products, :quarterly_sales_quantity, :default => 0, :null => false
  end
end
