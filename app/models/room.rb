class Room < ActiveRecord::Base
  set_table_name :rooms
  set_primary_key :room_id

  belongs_to :room_type, :primary_key => :room_type_id
  has_many :room_rates, :foreign_key => :room_id

  default_scope :conditions => "#{self.table_name}.voided = 0"

  def self.available_rooms
    available_rooms = []
    rooms = Room.find(:all)
    rooms.each do |room|
      room_status = RoomBooking.room_status(room.room_id)
      available_rooms << room if room_status.match(/available/i)
    end

    return available_rooms
  end

  def self.occupied_rooms
    occupied_rooms = []
    rooms = Room.find(:all)
    rooms.each do |room|
      room_status = RoomBooking.room_status(room.room_id)
      occupied_rooms << room if room_status.match(/occupied/i)
    end

    return occupied_rooms
  end

  def self.has_booking_records(room_id)
    booking_records = RoomBooking.find(:all, :joins => "INNER JOIN rooms ON room_bookings.room_id = rooms.room_id
      INNER JOIN bookings ON room_bookings.booking_id = bookings.booking_id",
      :conditions => ["rooms.room_id = '#{room_id}' AND rooms.voided = 0 AND bookings.voided = 0"])
    return booking_records
  end

end
