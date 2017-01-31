class RoomBooking < ActiveRecord::Base
  set_table_name :room_bookings
  set_primary_key :room_booking_id
  default_scope :conditions => "voided = 0"
end
