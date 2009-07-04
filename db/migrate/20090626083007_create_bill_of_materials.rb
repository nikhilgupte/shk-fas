class CreateBillOfMaterials < ActiveRecord::Migration
  extend MigrationHelpers

  def self.up
    create_table :bill_of_materials do |t|
      t.integer :production_plan_id, :null => false
      t.integer :created_by_id, :null => false
      t.string :remarks
      t.datetime :created_at
    end
    add_index :bill_of_materials, :production_plan_id
    foreign_key(:bill_of_materials, :production_plan_id, :production_plans, true)
    add_index :bill_of_materials, :created_by_id
    foreign_key(:bill_of_materials, :created_by_id, :users, false)
  end

  def self.down
    drop_table :bill_of_materials
  end
end
