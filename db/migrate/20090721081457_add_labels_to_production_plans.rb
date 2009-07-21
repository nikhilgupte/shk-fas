class AddLabelsToProductionPlans < ActiveRecord::Migration
  def self.up
    add_column :production_plans, :column_labels, :string
  end

  def self.down
    remove_column :production_plans, :column_labels
  end
end
