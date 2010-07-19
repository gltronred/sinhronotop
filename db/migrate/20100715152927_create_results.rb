class CreateResults < ActiveRecord::Migration
  def self.up
    create_table :results do |t|
      t.integer :score
      t.integer :team_id
      t.integer :event_id

      t.timestamps
    end
  end

  def self.down
    drop_table :results
  end
end
