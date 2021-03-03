class CreateMeetingrooms < ActiveRecord::Migration[6.0]
  def change
    create_table :meetingrooms do |t|
      t.string :name
      t.integer :price
      t.boolean :active
      t.string :description
      t.string :address
      t.float :latitude
      t.float :longitude

      t.timestamps
    end
  end
end
