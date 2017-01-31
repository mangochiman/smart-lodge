class Room < ActiveRecord::Base
  set_table_name :rooms
  set_primary_key :room_id
  default_scope :conditions => "voided = 0"
end
