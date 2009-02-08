class CreateCustomDuties < ActiveRecord::Migration
  def self.up
    create_table :custom_duties do |t|
      t.string :name, :null => false
      t.float :duty, :null => false
      t.timestamps

      t.timestamps
    end
    execute %{create unique index index_custom_duties_on_name on custom_duties(upper(name))}
  end

  def self.down
    drop_table :custom_duties
  end
end
