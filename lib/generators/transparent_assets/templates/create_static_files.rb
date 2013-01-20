class CreateStaticFiles < ActiveRecord::Migration
  def self.up
    create_table(:static_files, :id => false) do |t|
      t.string :file, :primary => true
      t.string :filename
      t.string :checksum
      t.integer :counter, default: 1
    end
  end

  def self.down
    drop_table :static_files
  end
end
