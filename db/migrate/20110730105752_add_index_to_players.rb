class AddIndexToPlayers < ActiveRecord::Migration
  def self.up
    add_index :players, :rating_id, :unique => true
  end

  def self.down
    remove_index :players, :rating_id
  end
end
