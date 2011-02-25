class AddEventFields < ActiveRecord::Migration
  def self.up
    add_column :tournaments, :time_required, :boolean
    add_column :events, :game_time, :string
    add_column :events, :more_info, :string, :limit => 1023
    add_column :events, :num_teams, :string
    Tournament.all.each{|tournament|tournament.time_required=false; tournament.save}
  end

  def self.down
    remove_column :tournaments, :time_required
    remove_column :events, :game_time
    remove_column :events, :more_info
    remove_column :events, :num_teams
  end
end
