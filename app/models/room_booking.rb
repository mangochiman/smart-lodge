class RoomBooking < ActiveRecord::Base
  set_table_name :room_bookings
  set_primary_key :room_booking_id

  has_one :room, :primary_key => "room_id", :foreign_key => "room_id"
  default_scope :conditions => "#{self.table_name}.voided = 0"

  def self.room(booking_id)
    room_booking = RoomBooking.find_last_by_booking_id(booking_id)
    return room_booking.room
  end
  
end
