class CreateLocations < ActiveRecord::Migration
  def change
    create_table :locations do |t|
      t.integer :neighborhood
      t.string :location
      t.integer :user_id
      t.timestamps null: false
    end
  end
end
