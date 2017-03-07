class Booking < ActiveRecord::Base
  set_table_name :bookings
  set_primary_key :booking_id

  belongs_to :person, :primary_key => "person_id", :foreign_key => "person_id"
  belongs_to :room_booking, :primary_key => "booking_id", :foreign_key => "booking_id"
  has_many :booking_statuses, :primary_key => "booking_id", :foreign_key => "booking_id"
  has_many :billable_items, :primary_key => "booking_id", :foreign_key => "booking_id"
  default_scope :conditions => "#{self.table_name}.voided = 0"

  def self.recent_bookings
    checkout_booking_ids = self.recent_checkouts.collect{|k, v|v.booking_id}
    checkout_booking_ids = [0] if checkout_booking_ids.blank?
    booking_statuses = BookingStatus.find(:all, :order => "booking_status_id DESC",
      :conditions => ["status =? AND booking_id NOT IN (?)", "checkin", checkout_booking_ids])

    booking_details = []
    booking_statuses.each do |booking_status|
      person = booking_status.booking.person
      booking_details << [person, booking_status]
    end
    return booking_details
  end

  def self.checkins_ever
    booking_statuses = BookingStatus.find(:all, :order => "booking_status_id DESC",
      :conditions => ["status =?", "checkin"])
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
      :conditions => ["status =?", "checkin"])
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
    available_bookings = BookingStatus.find(:all, :group => "booking_id", :conditions => ["status =?", "checkin"])
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
        booking_id, "checkin"])
    return booking_status.status_date
  end

  def self.checkout_client(booking_id)
    booking_status = BookingStatus.new
    booking_status.booking_id = booking_id
    booking_status.status = 'checkout'
    booking_status.status_date = Date.today
    if (booking_status.save)
      return true
    else
      return false
    end
  end

  def self.update_check_in_date(booking_id, start_date)
    booking_status = Booking.find(booking_id).booking_statuses.find(:last,
      :conditions => ["status =?", "checkin"])
    booking_status.status_date = start_date
    booking_status.save
    
    return booking_status
  end

  def self.void(booking_id)
    booking = Booking.find(booking_id)

    ActiveRecord::Base.transaction do

      booking.booking_statuses.each do |booking_status|
        booking_status.voided = 1
        booking_status.save
      end

      room_booking = booking.room_booking
      room_booking.voided = 1
      room_booking.save

      booking.billable_items.each do |billable_item|
        billable_item.voided = 1
        billable_item.save
      end

      booking.voided = 1
      booking.save
    end
    
    return true
  end
  
end
