class Booking < ActiveRecord::Base
  set_table_name :bookings
  set_primary_key :booking_id

  belongs_to :person, :primary_key => "person_id", :foreign_key => "person_id"
  belongs_to :room_booking, :primary_key => "booking_id", :foreign_key => "booking_id"
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
  
end
