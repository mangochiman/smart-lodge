class PrintController < ApplicationController
  layout 'print'

  def view_invoice_plain
    @room = Booking.room(params[:booking_id])
    @person = Booking.find(params[:booking_id]).person
    @page_title = "Invoice For  #{@person.first_name} #{@person.last_name} - Room #: <a>#{@room.number}</a>, Room Name: <a>#{@room.name}</a>"
    @booking = Booking.find(params[:booking_id])
    @billable_items = @booking.billable_items
    @taxes = Tax.find(:all)
    @check_in_date = Booking.check_in_date(params[:booking_id])
    @total_days_spent = (Date.today - @check_in_date.to_date).to_i
  end
  
end
