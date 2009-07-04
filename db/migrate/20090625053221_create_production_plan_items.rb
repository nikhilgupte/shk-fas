class CreateProductionPlanItems < ActiveRecord::Migration
  extend MigrationHelpers

  def self.up
    create_table :production_plan_items do |t|
      t.integer :production_plan_id, :null => false
      t.integer :product_id, :null => false
      (1..4).each do |i|
        t.float "quantity_#{i}", :null => false
      end
      t.datetime :created_at
    end
    add_index :production_plan_items, :product_id
    foreign_key(:production_plan_items, :product_id, :products, false)
    add_index :production_plan_items, :production_plan_id
    foreign_key(:production_plan_items, :production_plan_id, :production_plans, true)
  end

  def self.down
    drop_table :production_plan_items
  end
end
