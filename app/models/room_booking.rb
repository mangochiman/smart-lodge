class RoomBooking < ActiveRecord::Base
  set_table_name :room_bookings
  set_primary_key :room_booking_id

  has_one :room, :primary_key => "room_id", :foreign_key => "room_id"
  default_scope :conditions => "#{self.table_name}.voided = 0"

  def self.room(booking_id)
    room_booking = RoomBooking.find_last_by_booking_id(booking_id)
    return room_booking.room
  end

  def self.search(room_id)
    data = {}
    room_number = Room.find(room_id).number

    room_bookings = RoomBooking.find(:all, :conditions => ["room_id =?", room_id])
    count = 1
    room_bookings.each do |room_booking|
      data[count] = {}
      data[count][:room_number] = room_number
      data[count][:check_in_date] = Booking.check_in_date(room_booking.booking_id)
      data[count][:check_out_date] = Booking.checkout_date(room_booking.booking_id) rescue ''
      data[count][:customer_details] = Booking.customer_details(room_booking.booking_id)
      count = count + 1
    end

    return data
  end

end
