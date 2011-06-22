class CreatePlays < ActiveRecord::Migration
  def self.up
    create_table :plays do |t|
      t.integer :player_id
      t.integer :event_id
      t.integer :team_id
      t.string :status

      t.timestamps
    end
  end

  def self.down
    drop_table :plays
  end
end
