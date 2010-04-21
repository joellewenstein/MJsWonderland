class CreateVotes < ActiveRecord::Migration
  def self.up
    create_table :votes do |t|
      t.integer :user_id
      t.integer :event_id
      t.string :type
      t.string :comment

      t.timestamps
    end
  end

  def self.down
    drop_table :votes
  end
end
