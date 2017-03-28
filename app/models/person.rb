class Person < ActiveRecord::Base
  set_table_name :people
  set_primary_key :person_id
  default_scope :conditions => "#{self.table_name}.voided = 0"

  has_many :bookings, :primary_key => "person_id", :foreign_key => "person_id"
  def self.search(params)
    first_name = params[:first_name]
    last_name = params[:last_name]
    gender = params[:gender]
    people = Person.find(:all, :conditions => ["first_name LIKE (?) AND last_name LIKE (?)",
        '%' + first_name + '%', '%' + last_name + '%']) if gender.blank?

    people = Person.find(:all, :conditions => ["first_name LIKE (?) AND last_name LIKE (?)
    AND gender =?", '%' + first_name + '%', '%' + last_name + '%', gender]) unless gender.blank?
    
    return people
  end

  def self.retrieve_clean_records
    black_list_ids = BlackList.find(:all).map(&:person_id)
    black_list_ids = [0] if black_list_ids.blank?
    people = Person.find(:all, :conditions => ["person_id NOT IN (?)", black_list_ids])
    return people
  end

  def self.black_listed_records
    black_list_ids = BlackList.find(:all).map(&:person_id)
    black_list_ids = [0] if black_list_ids.blank?
    people = Person.find(:all, :conditions => ["person_id IN (?)", black_list_ids])
    return people
  end

  def self.date_black_listed(person_id)
    black_list = BlackList.find_by_person_id(person_id)
    return "" if black_list.blank?
    value_date = black_list.value_date
    return value_date
  end

  def self.checked_out?(person)
    checked_out = true

    person.bookings.each do |booking|
      booking_statuses = booking.booking_statuses.map(&:status)
      if booking_statuses.include?('checkout')
        next
      end
      checked_out = false
      break
    end
    
    return checked_out
  end

  def self.black_list_status(person)
    black_list = BlackList.find_by_person_id(person.person_id)
    unless black_list.blank?
      return "Yes"
    else
      return "No"
    end
  end
end
