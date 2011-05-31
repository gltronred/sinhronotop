class AddLink < ActiveRecord::Migration
  def self.up
    create_table :links do |t|
      t.string :url, :limit => 255
      t.integer :game_id
      t.integer :tournament_id
      t.timestamps
    end
  end

  def self.down
    drop_table :links
  end
end
