class CreateRoomTypes < ActiveRecord::Migration
  def self.up
    create_table :room_types, :primary_key => :room_type_id do |t|
      t.integer :max_capacity
      t.string :description
      t.timestamps
    end
  end

  def self.down
    drop_table :room_types
  end
end
