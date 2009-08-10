class AddFormulationToProducts < ActiveRecord::Migration
  extend MigrationHelpers

  def self.up
    add_column :products, :formulation_id, :integer
    add_index :products, :formulation_id
    foreign_key(:products, :formulation_id, :formulations, false)
  end

  def self.down
    remove_column :products, :formulation_id
  end
end
