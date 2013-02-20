class AddStandardQuantityToFormulations < ActiveRecord::Migration
  def self.up
    add_column :formulations, :standard_quantity, :decimal, :precision => 10, :scale => 3
  end

  def self.down
    remove_column :formulations, :standard_quantity
  end
end
