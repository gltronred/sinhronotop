class AddGameBeginEndAndNilability < ActiveRecord::Migration
  def self.up
    add_column :games, :game_begin, :date
    add_column :games, :game_end, :date
  end

  def self.down
    remove_column :games, :game_begin
    remove_column :games, :game_end
  end
end
