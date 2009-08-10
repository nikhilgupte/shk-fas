class CreateFormulations < ActiveRecord::Migration
  def self.up
    create_table :formulations do |t|
      t.string :name, :null => false
      t.string :code, :null => false

      t.timestamps
    end
    execute %{create unique index index_formulations_on_code on formulations(lower(code))}
  end

  def self.down
    drop_table :formulations
  end
end
