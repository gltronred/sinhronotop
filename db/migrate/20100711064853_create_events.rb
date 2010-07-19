class CreateEvents < ActiveRecord::Migration
  def self.up
    create_table :events do |t|
      t.date :date
      t.string :moderator_name
      t.string :moderator_email
      t.string :resp_name
      t.string :resp_email
      t.integer :city_id
      t.integer :game_id

      t.timestamps
    end
  end

  def self.down
    drop_table :events
  end
end
