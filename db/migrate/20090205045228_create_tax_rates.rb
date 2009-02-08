class CreateTaxRates < ActiveRecord::Migration
  def self.up
    create_table :tax_rates do |t|
      t.string :name, :null => false
      t.float :rate, :null => false
      t.timestamps
    end
    execute %{create unique index index_tax_rates_on_name on tax_rates(upper(name))}
  end

  def self.down
    drop_table :tax_rates
  end
end
