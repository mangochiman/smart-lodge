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

  def process_checkout
    if (Booking.checkout_client(params[:booking_id]))
      flash[:notice] = "Checkout is successful"
      redirect_to("/new_invoice?booking_id=#{params[:booking_id]}")
    else
      flash[:error] = "Failed to checkout the client"
      redirect_to("/check_out_client?booking_id=#{params[:booking_id]}")
    end
  end

  def cancel_client_checkout
    booking_status = BookingStatus.find(params[:booking_status_id])
    booking_status.voided = 1
    booking_status.save
    flash[:notice] = "Checkout successfully voided"
    redirect_to("/guests") and return
  end

  def cancel_client_booking
    void_booking = Booking.void(params[:booking_id])
    if void_booking
      flash[:notice] = "Booking successfully voided"
    else
      flash[:notice] = "Failed to void booking"
    end
    redirect_to("/guests") and return
  end
  
  def adjust_booking_menu
    @booking = Booking.find(params[:booking_id])
    @room = Booking.room(params[:booking_id])
    @person = @booking.person
    start_date = @booking.start_date.to_date.strftime("%m/%d/%Y") rescue ""
    end_date = @booking.end_date.to_date.strftime("%m/%d/%Y") rescue ""

    @booking_dates = ""
    unless start_date.blank?
      @booking_dates = "#{start_date}"
      unless end_date.blank?
        @booking_dates = "#{start_date} - #{end_date}"
      end
    end
    
    @page_title = "Adjusting booking For  #{@person.first_name} #{@person.last_name} - Room #: <a>#{@room.number}</a>, Room Name: <a>#{@room.name}</a>"

  end

  def update_booking
    booking = Booking.find(params[:booking_id])
    reservation_dates = params[:reservation_dates].split("-")
    start_date = reservation_dates[0].to_date
    end_date = reservation_dates[1].to_date
    
    if booking.update_attributes({
          :start_date => start_date,
          :end_date => end_date
        }){
      }
      Booking.update_check_in_date(params[:booking_id], start_date)
      flash[:notice] = "You have successfully updated the booking"
      redirect_to("/guests")
    else
      flash[:error] = "Failed to do the update"
      redirect_to("/adjust_booking_menu?booking_id=#{params[:booking_id]}")
    end
  end
  
  def invoices_menu
    @page_title = "Invoices"
    @available_unique_bookings = Booking.available_unique_bookings
  end

  def new_invoice
    @page_title = "New Invoice"
    @booking = Booking.find(params[:booking_id])
    @billable_items = @booking.billable_items
    @person = Booking.find(params[:booking_id]).person
  end

  def create_invoice_items
    billable_item = BillableItem.new(params[:invoice])
    if billable_item.save
      flash[:notice] = "You have successfully added new item"
      redirect_to("/new_invoice?booking_id=#{params[:invoice][:booking_id]}")
    else
      flash[:error] = "Failed to add new item"
      redirect_to("/new_invoice?booking_id=#{params[:invoice][:booking_id]}")
    end
  end

  def void_billable_item
    billable_item = BillableItem.find(params[:billable_item_id])
    billable_item.voided = 1
    if billable_item.save
      flash[:notice] = "You have successfull removed the item"
    else
      flash[:error] = "Failed to removed the item"
    end
    
    redirect_to("/new_invoice?booking_id=#{params[:booking_id]}")
  end

  def view_invoice
    @room = Booking.room(params[:booking_id])
    @person = Booking.find(params[:booking_id]).person
    @page_title = "Invoice For  #{@person.first_name} #{@person.last_name} - Room #: <a>#{@room.number}</a>, Room Name: <a>#{@room.name}</a>"
    @booking = Booking.find(params[:booking_id])
    @billable_items = @booking.billable_items
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
      booking_status.status = 'checkin'
      booking_status.status_date = Date.today
      booking_status.save

      flash[:notice] = "Check-in is successful"
    else
      flash[:error] = "There was an error"
    end
    
    redirect_to("/check_in_menu")
  end

  def view_customers_menu
    @page_title = "View Customers"
    @people = Person.all
  end

  def edit_personal_details
    @person = Person.find(params[:person_id])
    @page_title = "Editing details of <a>#{@person.first_name} #{@person.last_name}</a>"
  end

  def update_personal_details
    person = Person.find(params[:person_id])
    if person.update_attributes(params[:person])
      flash[:notice] = "You have successfully updated the details"
    else
      flash[:error] = "Failed to update the details"
    end
    redirect_to("/view_customers_menu")
  end

  def personal_booking_details
    @person = Person.find(params[:person_id])
    @page_title = "Booking details of <a>#{@person.first_name} #{@person.last_name}</a>"
    @booking_history = Booking.history(params[:person_id])
  end

  def report_menu
    @page_title = "Reports"
  end

  def bookings_by_gender_report_menu
    @page_title = "Bookings by gender report"
  end

  def bookings_by_custom_date_report_menu
    @page_title = "Bookings by custom date report"
  end

  def bookings_by_room_report_menu
    @page_title = "Bookings by room report"
  end
end
