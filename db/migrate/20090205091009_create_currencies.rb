class CreateCurrencies < ActiveRecord::Migration
  def self.up
    create_table :currencies do |t|
      t.string :name
      t.float :inr_value
    end
    execute %{create unique index index_currencies_on_name on currencies(lower(name))}
    Currency.create!(:name => 'INR', :inr_value => 1)
    Currency.create!(:name => 'USD', :inr_value => 48.665)
    Currency.create!(:name => 'EUR', :inr_value => 62.554)
  end

  def self.down
    drop_table :currencies
  end
end
