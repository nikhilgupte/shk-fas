class DropProductionCodeFromProducts < ActiveRecord::Migration
  def self.up
    remove_column :products, :production_code
  end

  def self.down
    add_column :products, :production_code, :string
  end
end
