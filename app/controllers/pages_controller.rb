class PagesController < ApplicationController
  layout "guests"
  def guests
    @page_title = "Guests Dashboard"
  end

  def check_in_menu
    @page_title = "Check In"
  end

  def check_out_menu
    @page_title = "Check Out"
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
  
end
