class Booking < ActiveRecord::Base
  set_table_name :bookings
  set_primary_key :booking_id

  belongs_to :person, :primary_key => "person_id", :foreign_key => "person_id"
  belongs_to :room_booking, :primary_key => "booking_id", :foreign_key => "booking_id"
  has_many :booking_statuses, :primary_key => "booking_id", :foreign_key => "booking_id"
  default_scope :conditions => "#{self.table_name}.voided = 0"

  def self.recent_bookings
    booking_statuses = BookingStatus.find(:all, :order => "booking_status_id DESC",
      :conditions => ["status =?", "active"])
    booking_details = []
    booking_statuses.each do |booking_status|
      person = booking_status.booking.person
      booking_details << [person, booking_status]
    end
    return booking_details
  end

  def self.checkins_ever
    booking_statuses = BookingStatus.find(:all, :order => "booking_status_id DESC",
      :conditions => ["status =?", "active"])
    booking_details = []
    booking_statuses.each do |booking_status|
      person = booking_status.booking.person
      booking_details << [person, booking_status]
    end
    return booking_details
  end

  def self.recent_checkouts
    booking_statuses = BookingStatus.find(:all, :order => "booking_status_id DESC",
      :conditions => ["status =?", "checkout"])
    booking_details = []
    booking_statuses.each do |booking_status|
      person = booking_status.booking.person
      booking_details << [person, booking_status]
    end
    return booking_details
  end

  def self.checkouts_ever
    booking_statuses = BookingStatus.find(:all, :order => "booking_status_id DESC",
      :conditions => ["status =?", "checkout"])
    booking_details = []
    booking_statuses.each do |booking_status|
      person = booking_status.booking.person
      booking_details << [person, booking_status]
    end
    return booking_details
  end

  def self.checkout_date(booking_id)
    return "&nbsp;"
  end

  def self.active_check_ins
    active_booking_statuses = BookingStatus.find(:all, :order => "booking_status_id DESC",
      :conditions => ["status =?", "active"])
    booking_details = []

    active_booking_statuses.each do |booking_status|
      booking = booking_status.booking
      booking_statuses = booking.booking_statuses.map(&:status)
      
      if (booking_statuses.include?('checkout'))
        next
      end
      person = booking.person
      booking_details << [person, booking_status]
    end
    
    return booking_details
  end

  def self.available_unique_bookings
    available_bookings = BookingStatus.find(:all, :group => "booking_id", :conditions => ["status =?", "active"])
    booking_details = []

    available_bookings.each do |booking_status|
      person = booking_status.booking.person
      booking_details << [person, booking_status]
    end
    
    return booking_details
  end

  def self.room(booking_id)
    room_booking = RoomBooking.find_last_by_booking_id(booking_id)
    room = room_booking.room
    return room
  end

  def self.check_in_date(booking_id)
    booking_status = BookingStatus.find(:last, :conditions => ["booking_id =? AND status =?",
        booking_id, "active"])
    return booking_status.status_date
  end

end
