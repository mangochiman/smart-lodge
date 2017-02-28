class PagesController < ApplicationController
  layout "guests"
  def guests
    @page_title = "Guests Dashboard"
    @recent_check_ins = Booking.recent_bookings #Booking.find(:all, :order => "booking_id DESC", :conditions => ["status =?", "active"])
    @recent_check_outs = Booking.recent_checkouts
    @available_rooms = Room.available_rooms
    @occupied_rooms = Room.occupied_rooms
  end

  def check_in_menu
    @page_title = "Check In"
    @rooms = Room.available_rooms
  end

  def check_out_menu
    @page_title = "Check Out"
    @active_check_ins = Booking.active_check_ins
  end

  def check_out_client
    @room = Booking.room(params[:booking_id])
    @page_title = "Check Out - Room #: <a>#{@room.number}</a>, Room Name: <a>#{@room.name}</a>"
    @person = Booking.find(params[:booking_id]).person
    @check_in_date = Booking.check_in_date(params[:booking_id])
    @total_days_spent = (Date.today - @check_in_date.to_date).to_i
  end
  
  def invoices_menu
    @page_title = "Invoices"
    @available_unique_bookings = Booking.available_unique_bookings
  end

  def new_invoice
    @booking = Booking.find(params[:booking_id])
  end

  def view_invoice
    @room = Booking.room(params[:booking_id])
    @person = Booking.find(params[:booking_id]).person
    @page_title = "Invoice For  #{@person.first_name} #{@person.last_name} - Room #: <a>#{@room.number}</a>, Room Name: <a>#{@room.name}</a>"

    @check_in_date = Booking.check_in_date(params[:booking_id])
    @total_days_spent = (Date.today - @check_in_date.to_date).to_i
  end
  
  def new_payment_menu
    @page_title = "New payments"
  end

  def view_payments_menu
    @page_title = "View Payments"
  end

  def view_all_check_ins_menu
    @page_title = "View all check ins"
    @checkins_ever = Booking.checkins_ever
  end

  def view_all_check_outs_menu
    @page_title = "View all check outs"
    @checkouts_ever = Booking.checkouts_ever
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
