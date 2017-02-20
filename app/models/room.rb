class Room < ActiveRecord::Base
  set_table_name :rooms
  set_primary_key :room_id

  belongs_to :room_type, :primary_key => :room_type_id
  has_many :room_rates, :foreign_key => :room_id

  default_scope :conditions => "#{self.table_name}.voided = 0"

  def self.available_rooms
    occupied_room_ids =  self.occupied_rooms.collect{|r|r.room_id}
    occupied_room_ids = ['0'] if occupied_room_ids.blank?
    rooms = Room.find(:all, :conditions => ["room_id NOT IN (?)", occupied_room_ids])
    return rooms
  end

  def self.occupied_rooms
    rooms = RoomBooking.find(:all, :joins => "INNER JOIN bookings ON room_bookings.booking_id = bookings.booking_id",
      :conditions => ["bookings.status = ?", 'active']
    ).collect{|rb|rb.room}
    return rooms
  end

end
