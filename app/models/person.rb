class Person < ActiveRecord::Base
  set_table_name :people
  set_primary_key :person_id
  default_scope :conditions => "voided = 0"
end
