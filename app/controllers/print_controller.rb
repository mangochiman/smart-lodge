class PrintController < ApplicationController
  skip_before_filter :authenticate_user
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

  def download_invoice
    booking_id = params[:booking_id]
    person = Booking.find(booking_id).person
    t1 = Thread.new{
      Kernel.system "wkhtmltopdf --margin-top 0 --margin-bottom 0 -s A4 http://" +
        request.env["HTTP_HOST"] + "\"/print/view_invoice_plain/?booking_id=#{booking_id}" + "\" /tmp/invoice_#{booking_id}" + ".pdf \n"
    }
    t1.join

    pdf_filename = "/tmp/invoice_#{booking_id}.pdf"
    send_file(pdf_filename, :filename => "#{person.first_name}_#{person.last_name}", :type => "application/pdf")
  end

  def print_invoice
    booking_id = params[:booking_id]
    person = Booking.find(booking_id).person
    t1 = Thread.new{
      Kernel.system "wkhtmltopdf --margin-top 0 --margin-bottom 0 -s A4 http://" +
        request.env["HTTP_HOST"] + "\"/print/view_invoice_plain/?booking_id=#{booking_id}" + "\" /tmp/invoice_#{booking_id}" + ".pdf \n"
    }
    t1.join
    
    #file = "invoice_#{booking_id}" + ".pdf"
    pdf_filename = "/tmp/invoice_#{booking_id}.pdf"
    #t2 = Thread.new{
    #sleep(3)
    #print(file, current_printer)
    #}
    send_file(pdf_filename, :filename => "#{person.first_name}_#{person.last_name}", :type => "application/pdf")
  end

  def print(file_name, current_printer)
    sleep(3)
    if (File.exists?(file_name))
      Kernel.system "lp -o sides=two-sided-long-edge -o fitplot #{(!current_printer.blank? ? '-d ' + current_printer.to_s : "")} #{file_name}"
    else
      print(file_name)
    end
  end

end
