class CreateBookings < ActiveRecord::Migration
  def self.up
    create_table :bookings, :primary_key => :booking_id do |t|
      t.integer :person_id
      t.date :start_date
      t.date :end_date
      t.integer :creator
      t.integer :voided, :default => 0
      t.timestamps
    end
  end

  def self.down
    drop_table :bookings
  end
end
