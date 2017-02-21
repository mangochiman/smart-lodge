class PagesController < ApplicationController
  layout "guests"
  def guests
    @page_title = "Guests Dashboard"
    @recent_check_ins = Booking.find(:all, :order => "booking_id DESC", :conditions => ["status =?", "active"])
    @available_rooms = Room.available_rooms
    @occupied_rooms = Room.occupied_rooms
  end

  def check_in_menu
    @page_title = "Check In"
    @rooms = Room.available_rooms
  end

  def check_out_menu
    @page_title = "Check Out"
    @people = Person.all
  end

  def invoices_menu
    @page_title = "Invoices"
  end

  def new_payment_menu
    @page_title = "New payments"
  end

  def view_payments_menu
    @page_title = "View Payments"
  end

  def search_results
    @page_title = "Search Results"
    @people = Person.search(params)
  end

  def create_bookings
    person = Person.new(params[:person])
    reservation_dates = params[:reservation_dates].split("-")
    start_date = reservation_dates[0].to_date
    end_date = reservation_dates[1].to_date
    room_id = params[:room_id]
    
    if person.save
      booking = Booking.new
      booking.person_id = person.person_id
      booking.start_date = start_date
      booking.end_date = end_date
      #booking.status = 'active'
      booking.save
      
      room_booking = RoomBooking.new
      room_booking.booking_id = booking.booking_id
      room_booking.room_id = room_id
      room_booking.save

      booking_status = BookingStatus.new
      booking_status.booking_id = booking.booking_id
      booking_status.status = 'active'
      booking_status.status_date = Date.today
      booking_status.save

      flash[:notice] = "Check-in is successful"
    else
      flash[:error] = "There was an error"
    end
    
    redirect_to("/check_in_menu")
  end
  
end
