class CreateProducts < ActiveRecord::Migration
  def self.up
    create_table :products do |t|
      t.string :code, :null => false
      t.string :name, :null => false
      t.float :quarterly_sales_quantity, :default => 0, :null => false
      t.string :production_code, :string

      t.timestamps
    end
    execute %{create unique index index_products_on_code on products(lower(code))}
  end

  def self.down
    drop_table :products
  end
end
