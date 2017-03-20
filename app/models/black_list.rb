class BlackList < ActiveRecord::Base
  set_table_name :black_lists
  set_primary_key :black_list_id
  default_scope :conditions => "#{self.table_name}.voided = 0"
end
