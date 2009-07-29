class CreateExportLogs < ActiveRecord::Migration
  def self.up
    create_table :export_logs do |t|
      t.integer :user_id
      t.timestamp :created_at, :null => false
    end
  end

  def self.down
    drop_table :export_logs
  end
end
