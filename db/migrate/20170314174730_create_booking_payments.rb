class CreateBookingPayments < ActiveRecord::Migration
  def self.up
    create_table :booking_payments, :primary_key => :booking_payment_id do |t|
      t.integer :booking_id
      t.string :mode_of_payment
      t.float :amount_paid
      t.integer :voided, :default => 0
      t.timestamps
    end
  end

  def self.down
    drop_table :booking_payments
  end
end
