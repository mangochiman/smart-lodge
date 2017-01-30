class CreatePeople < ActiveRecord::Migration
  def self.up
    create_table :people, :primary_key => :person_id do |t|
      t.string :first_name
      t.string :last_name
      t.string :gender
      t.string :email
      t.string :title
      t.string :phone_number
      t.string :address
      t.integer :creator
      t.integer :voided
      t.timestamps
    end
  end

  def self.down
    drop_table :people
  end
end
