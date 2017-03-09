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
  
end
