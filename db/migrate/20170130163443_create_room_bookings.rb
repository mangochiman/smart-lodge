class CreateRoomBookings < ActiveRecord::Migration
  def self.up
    create_table :room_bookings, :primary_key => :room_booking_id do |t|
      t.integer :booking_id
      t.integer :room_id
      t.integer :creator
      t.integer :voided, :default => 0
      t.timestamps
    end
  end

  def self.down
    drop_table :room_bookings
  end
end
