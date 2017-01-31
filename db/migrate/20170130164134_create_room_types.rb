class CreateRoomTypes < ActiveRecord::Migration
  def self.up
    create_table :room_types, :primary_key => :room_type_id do |t|
      t.integer :max_capacity
      t.string :room_type
      t.string :description
      t.integer :voided, :default => 0
      t.timestamps
    end
  end

  def self.down
    drop_table :room_types
  end
end
