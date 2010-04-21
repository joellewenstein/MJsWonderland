class CreateEvents < ActiveRecord::Migration
  def self.up
    create_table :events do |t|
      t.integer :jambase_id
      t.date :date
      t.string :ticket_url
      t.string :event_url
      t.integer :venue_id

      t.timestamps
    end
  end

  def self.down
    drop_table :events
  end
end
