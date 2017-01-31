class RoomType < ActiveRecord::Base
  set_table_name :room_types
  set_primary_key :room_type_id
  default_scope :conditions => "voided = 0"
end
