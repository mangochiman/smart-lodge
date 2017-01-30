class Person < ActiveRecord::Base
  set_table_name :people
  set_primary_key :person_id
end
