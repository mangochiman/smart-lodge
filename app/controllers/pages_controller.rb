class PagesController < ApplicationController
  before_filter :lock_screen_when_activated, :except => [:lock_screen, :unlock_screen]
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

  def check_in_existing_customer
    @page_title = "Check-in existing customer"
    @person = Person.find(params[:person_id])
    @rooms = Room.available_rooms

    if request.post?
      reservation_dates = params[:reservation_dates].split("-")
      start_date = reservation_dates[0].to_date
      end_date = reservation_dates[1].to_date
      room_id = params[:room_id]

      ActiveRecord::Base.transaction do
        booking = Booking.new
        booking.person_id = params[:person_id]
        booking.start_date = start_date
        booking.end_date = end_date
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
      end

      flash[:notice] = "#{@person.first_name} #{@person.last_name} has been Checked-in successfuly"
      redirect_to("/guests")
    end
  end
  
  def check_out_menu
    @page_title = "Check Out"
    @active_check_ins = Booking.active_check_ins
    @occupied_rooms = Room.occupied_rooms
  end

  def check_out_client
    @room = Booking.room(params[:booking_id])
    @page_title = "Check Out - Room #: <a>#{@room.number}</a>, Room Name: <a>#{@room.name}</a>"
    @person = Booking.find(params[:booking_id]).person
    @check_in_date = Booking.check_in_date(params[:booking_id])
    @today = Date.today.strftime("%m/%d/%Y")
    @total_days_spent = (Date.today - @check_in_date.to_date).to_i
  end

  def process_checkout
    checkout_date = params[:checkout_date].to_date
    if (Booking.checkout_client(params[:booking_id], checkout_date))
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
    
    @available_invoices_bookings = Booking.available_invoices
    @missing_invoices_bookings = Booking.missing_invoices
  end

  def new_invoice
    @page_title = "New Invoice"
    @booking = Booking.find(params[:booking_id])
    @billable_items = @booking.billable_items
    @taxes = Tax.find(:all)
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
    @taxes = Tax.find(:all)
    @check_in_date = Booking.check_in_date(params[:booking_id])
    @total_days_spent = (Date.today - @check_in_date.to_date).to_i
  end

  def view_invoice_plain
    @room = Booking.room(params[:booking_id])
    @person = Booking.find(params[:booking_id]).person
    @page_title = "Invoice For  #{@person.first_name} #{@person.last_name} - Room #: <a>#{@room.number}</a>, Room Name: <a>#{@room.name}</a>"
    @booking = Booking.find(params[:booking_id])
    @billable_items = @booking.billable_items
    @taxes = Tax.find(:all)
    @check_in_date = Booking.check_in_date(params[:booking_id])
    @total_days_spent = (Date.today - @check_in_date.to_date).to_i
    render :layout => false
  end

  def new_payment_menu
    @page_title = "New payments <span class='label label-info'>Only possible for customers that are not checked out</span>"
    @active_check_ins = Booking.active_check_ins
  end

  def make_payment
    @room = Booking.room(params[:booking_id])
    @person = Booking.find(params[:booking_id]).person
    @check_in_date = Booking.check_in_date(params[:booking_id])
    @page_title = "Payment For  #{@person.first_name} #{@person.last_name} - Room #: <a>#{@room.number}</a>, Room Name: <a>#{@room.name}</a>, Checkin Date: <a>#{@check_in_date.to_date.strftime('%d/%b/%Y')}</a>"
    @booking = Booking.find(params[:booking_id])
    @billable_items = @booking.billable_items
    
    @amount_required = @booking.billable_items.inject(0){|sum,x| sum + (x.price * x.quantity) } #fancy way of doing sum
    @total_days_spent = (Date.today - @check_in_date.to_date).to_i
  end

  def process_payment
    booking_payment = BookingPayment.new
    booking_payment.booking_id = params[:booking_id]
    booking_payment.mode_of_payment = params[:mode_of_payment]
    booking_payment.amount_paid = params[:amount_paid]
    if booking_payment.save
      flash[:notice] = "Payment successfully saved"
      redirect_to("/view_payments_menu") and return
    else
      flash[:error] = "Failed to save the payment"
      redirect_to("/make_payment?booking_id=#{params[:booking_id]}") and return
    end

  end

  def delete_payment
    booking = Booking.find(params[:booking_id])
    booking.booking_payments.each do |booking_payment|
      booking_payment.voided = 1
      booking_payment.save
    end
    flash[:notice] = "Operation successful"
    redirect_to("/view_payments_menu")
  end
  
  def view_payments_menu
    @page_title = "View Payments"
    @bookings = Booking.recent_payments
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
    @people = Person.search(params)
    string = "results"
    string = "result" if @people.count == 1
    @page_title = "Search Results: <b>#{@people.count}</b> #{string} found"
    
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
    @people = Person.all
    @people = [] if params[:gender].blank?

    unless params[:gender].blank?
      gender = params[:gender]
      gender = ["Male", "Female"] if params[:gender] == 'ALL'
      @people = Person.find(:all, :joins => "INNER JOIN bookings ON people.person_id = bookings.person_id",
        :conditions => ["gender IN (?)", gender],
        :group => "booking_id")
    end
  end

  def bookings_by_custom_date_report_menu
    @page_title = "Bookings by custom date report"
    @today = Date.today.strftime("%m/%d/%Y") + ' - ' + Date.today.strftime("%m/%d/%Y")
    @people = [] if params[:dates].blank?
    
    unless params[:dates].blank?
      start_date = params[:dates].split("-")[0].to_date
      end_date = params[:dates].split("-")[1].to_date
      
      @people = Person.find(:all, :joins => "INNER JOIN bookings ON people.person_id = bookings.person_id INNER JOIN booking_statuses ON bookings.booking_id = booking_statuses.booking_id",
        :conditions => ["DATE(status_date) >= ? AND DATE(status_date) <= ? AND status = ?", start_date, end_date, 'checkin'],
        :group => "bookings.booking_id")
    end
  end

  def bookings_by_room_report_menu
    @page_title = "Bookings by room report"
    @people = [] if params[:room_id].blank?

    unless params[:room_id].blank?
      @people = Person.find(:all, :joins => "INNER JOIN bookings ON people.person_id = bookings.person_id INNER JOIN room_bookings ON bookings.booking_id = room_bookings.booking_id",
        :conditions => ["room_id =?", params[:room_id]],
        :group => "bookings.booking_id")
    end
  end

  def checkout_report_menu
    @page_title = "Checkout report"
    @checkouts_data = []
    unless params[:dates].blank?
      start_date = params[:dates].split("-")[0].to_date
      end_date = params[:dates].split("-")[1].to_date
      @checkouts_data = Booking.checkouts_by_date_range(start_date, end_date)
    else
      start_date = Booking.first_check_out_date
      end_date = Booking.last_check_out_date
      @checkouts_data = Booking.checkouts_by_date_range(start_date, end_date)
    end
  end

  def payments_report_menu
    @page_title = "Payments report"
    @booking_payments = Booking.payments
  end

  def black_list_report_menu
    @page_title = "Blacklist report"
    @black_listed_people = Person.black_listed_records
  end
  
  def search_rooms
    @page_title = "Search Rooms"
    @search_results = []
    unless params[:room_id].blank?
      @room_name = Room.find(params[:room_id]).name
      @room_status = RoomBooking.room_status(params[:room_id])
      @search_results = RoomBooking.search(params[:room_id])
    end
  end

  def new_black_list_menu
    @page_title = "New Blacklist Record"
    @people = Person.retrieve_clean_records
  end

  def black_list_client
    person = Person.find(params[:person_id])
    black_list = BlackList.new
    black_list.person_id = params[:person_id]
    black_list.value_date = Date.today
    if black_list.save
      flash[:notice] = "#{person.first_name} #{person.last_name} has been black listed"
      redirect_to("/view_black_list_menu") and return
    else
      flash[:error] = "Failed to blacklist #{person.first_name} #{person.last_name}"
      redirect_to("/new_black_list_menu") and return
    end
    
  end

  def cancel_black_listed_client
    person = Person.find(params[:person_id])
    person_records = BlackList.find(:all, :conditions => ["person_id =?", params[:person_id]])
    person_records.each do |person_record|
      person_record.voided = 1
      person_record.save
    end

    flash[:notice] = "#{person.first_name} #{person.last_name} has been removed from black list records"
    redirect_to("/delete_black_list_menu") and return
  end
  
  def view_black_list_menu
    @page_title = "View Blacklist Records"
    @people = Person.black_listed_records
  end

  def delete_black_list_menu
    @page_title = "View Blacklist Records"
    @people = Person.black_listed_records
  end

  def lock_screen
    session[:screen_locked] = true
    http_referrer = request.env["HTTP_REFERER"]

    unless (http_referrer.blank? || (http_referrer.match(/lock_screen/i)))
      session[:referrer] = request.referrer
    end
 
    render :layout => false
  end

  def unlock_screen
    username = User.current_user.username
    logged_in_user = User.authenticate(username, params[:password])

    if logged_in_user
      session.delete(:screen_locked) if session[:screen_locked]
      (redirect_to("#{session[:referrer]}") and return) unless session[:referrer].blank?
      redirect_to("/") and return
    else
      #flash[:error] = "Invalid password"
      #request.referrer = session[:referrer]
      #return
      redirect_to("/lock_screen") and return
    end
  end

  def my_account_guests
    @page_title = "My Profile"
    @user = User.find(session[:user].user_id)
  end

  def view_all_available_rooms
    @page_title = "View available rooms"
    @available_rooms = Room.available_rooms
  end

  def view_all_occupied_rooms
    @page_title = "View occupied rooms"
    @occupied_rooms = Room.occupied_rooms
  end

end
