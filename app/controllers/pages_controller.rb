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

  def search_results
    @page_title = "Search Results"
    @people = Person.search(params)
  end

  def create_bookings
    person = Person.new(params[:person])
    if person.save
      flash[:notice] = "Check-in is successful"
    else
      flash[:error] = "There was an error"
    end
    redirect_to("/check_in_menu")
  end
end
