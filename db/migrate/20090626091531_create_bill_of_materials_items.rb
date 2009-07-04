class CreateBillOfMaterialsItems < ActiveRecord::Migration
  extend MigrationHelpers

  def self.up
    create_table :bill_of_materials_items do |t|
      t.integer :bill_of_materials_id, :null => false
      t.integer :ingredient_id
      t.string :ingredient_name, :null => false
      t.string :ingredient_code, :null => false
      (1..4).each do |i|
        t.float "quantity_#{i}", :null => false
      end
    end
    add_index :bill_of_materials_items, :bill_of_materials_id
    foreign_key(:bill_of_materials_items, :bill_of_materials_id, :bill_of_materials, true)
    add_index :bill_of_materials_items, :ingredient_id
    foreign_key(:bill_of_materials_items, :ingredient_id, :ingredients, false)
  end

  def self.down
    drop_table :bill_of_materials_items
  end
end
