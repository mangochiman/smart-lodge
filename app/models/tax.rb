class Tax < ActiveRecord::Base
  set_table_name :taxes
  set_primary_key :tax_id
  default_scope :conditions => "#{self.table_name}.voided = 0"
end
