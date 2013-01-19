class CreateUuids < ActiveRecord::Migration
  def self.up
    create_table(:uuids, :id => false) do |t|
      t.string :uuid, :primary => true
      t.string :filename
      t.integer :counter, default: 1
    end
  end

  def self.down
    drop_table :uuids
  end
end
