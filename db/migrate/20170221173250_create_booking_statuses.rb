class CreateBookingStatuses < ActiveRecord::Migration
  def self.up
    create_table :booking_statuses, :primary_key => :booking_status_id do |t|
      t.integer :booking_id
      t.string :status
      t.date :status_date
      t.integer :voided, :default => 0
      t.timestamps
    end
  end

  def self.down
    drop_table :booking_statuses
  end
end
