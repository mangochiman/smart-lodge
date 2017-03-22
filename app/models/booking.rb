class Booking < ActiveRecord::Base
  set_table_name :bookings
  set_primary_key :booking_id

  belongs_to :person, :primary_key => "person_id", :foreign_key => "person_id"
  belongs_to :room_booking, :primary_key => "booking_id", :foreign_key => "booking_id"
  has_many :booking_statuses, :primary_key => "booking_id", :foreign_key => "booking_id"
  has_many :billable_items, :primary_key => "booking_id", :foreign_key => "booking_id"
  has_many :booking_payments, :primary_key => "booking_id", :foreign_key => "booking_id"
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

  def self.checkouts_by_date_range(start_date, end_date)
    booking_statuses = BookingStatus.find(:all, :order => "booking_status_id DESC",
      :conditions => ["status =? AND DATE(status_date) >= ? AND DATE(status_date) <= ?", "checkout", start_date, end_date])
    booking_details = []
    booking_statuses.each do |booking_status|
      person = booking_status.booking.person
      booking_details << [person, booking_status]
    end
    return booking_details
  end

  def self.checkout_date(booking_id)
    booking_status = BookingStatus.find(:last, :conditions => ["booking_id =? AND status =?",
        booking_id, "checkout"])
    return booking_status.status_date
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

  def self.history(person_id)
    booking_history = {}
    person = Person.find(person_id)
    bookings = person.bookings
    
    bookings.each do |booking|
      booking_id = booking.booking_id
      checkin_date = self.check_in_date(booking_id) rescue ''
      checkout_date = self.checkout_date(booking_id) rescue ''
      room = self.room(booking_id).name rescue ''
      
      booking_history[booking_id] = {
        :check_in_date => checkin_date,
        :check_out_date => checkout_date,
        :room => room
      }
    end
    
    return booking_history
  end

  def self.recent_payments
    bookings = Booking.find(:all, :joins => "INNER JOIN booking_payments ON bookings.booking_id = booking_payments.booking_id",
      :conditions => ["booking_payments.voided=0 AND bookings.voided=0"], :group => "bookings.booking_id")
    return bookings
  end

  def self.mode_of_payment(booking_id)
    booking_payment = BookingPayment.find(:last, :conditions => ["booking_id =?", booking_id])
    return "" if booking_payment.blank?
    return booking_payment.mode_of_payment
  end

  def self.amount_paid(booking_id)
    booking = Booking.find(booking_id)
    total_amount_paid = booking.booking_payments.inject(0){|sum, booking_payment| sum + booking_payment.amount_paid }
    return total_amount_paid
  end

  def self.customer_details(booking_id)
    data = ""
    booking = Booking.find(booking_id)
    person = booking.person
    data = "Names: <a href='#'>#{person.first_name} #{person.last_name}</a>, Phone #: <a href='#'>#{person.phone_number}</a>, E-mail #: <a href='#'>#{person.email}</a>"
    return data
  end

  def self.first_check_out_date
    booking_status = BookingStatus.find(:first, :order => "DATE(status_date) ASC", :conditions => ["status =?", "checkout"])
    return booking_status.status_date
  end

  def self.last_check_out_date
    booking_status = BookingStatus.find(:last, :order => "DATE(status_date) ASC", :conditions => ["status =?", "checkout"])
    return booking_status.status_date
  end

  def self.available_invoices
    bookings = Booking.find(:all, :joins => "INNER JOIN billable_items ON bookings.booking_id = billable_items.booking_id",
    :group => "bookings.booking_id", :conditions => ["billable_items.voided=0"])
    return bookings
  end

  def self.missing_invoices
    booking_ids = BillableItem.find(:all).map(&:booking_id).uniq
    booking_ids = [0] if booking_ids.blank?
    bookings = Booking.find(:all, :conditions => ["booking_id NOT IN (?)", booking_ids])
    return bookings
  end

  def self.payments
   booking_payments = BookingPayment.find(:all, :joins => "INNER JOIN bookings ON booking_payments.booking_id = bookings.booking_id",
    :conditions => ["bookings.voided = ?", 0], :order => "booking_payment_id DESC", :group => "bookings.person_id")
   return booking_payments
  end

end
