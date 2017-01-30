class CreateRooms < ActiveRecord::Migration
  def self.up
    create_table :rooms, :primary_key => :room_id do |t|
      t.integer :number
      t.string :name
      t.integer :room_type_id
      t.integer :creator
      t.integer :voided
      t.timestamps
    end
  end

  def self.down
    drop_table :rooms
  end
end
