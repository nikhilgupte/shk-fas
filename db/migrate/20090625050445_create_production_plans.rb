class CreateProductionPlans < ActiveRecord::Migration
  extend MigrationHelpers

  def self.up
    create_table :production_plans do |t|
      t.integer :created_by_id, :null => false
      t.string :forecast_type, :null => false
      t.string :location
      t.string :remarks
      t.datetime :submitted_at

      t.timestamps
    end
    add_index :production_plans, :created_by_id
    foreign_key(:production_plans, :created_by_id, :users, false)
  end

  def self.down
    drop_table :production_plans
  end
end
