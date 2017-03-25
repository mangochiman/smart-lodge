class RoomType < ActiveRecord::Base
  set_table_name :room_types
  set_primary_key :room_type_id
  default_scope :conditions => "#{self.table_name}.voided = 0"

  has_many :rooms, :foreign_key => :room_type_id

  def self.has_booking_records(room_type_id)
    booking_records = RoomBooking.find(:all, :joins => "INNER JOIN rooms ON room_bookings.room_id = rooms.room_id
      INNER JOIN bookings ON room_bookings.booking_id = bookings.booking_id", 
      :conditions => ["room_type_id = '#{room_type_id}' AND rooms.voided = 0 AND bookings.voided = 0"])
    return booking_records
  end

end
