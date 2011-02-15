class AddResultCalcul < ActiveRecord::Migration
  def self.up
    create_table "tournament_results", :force => true do |t|
      t.float   :place,                      :default => 0
      t.integer :tournament_id
      t.integer :team_id
    end
    create_table "calc_systems", :force => true do |t|
      t.string :short_name
      t.string :name
    end
    add_column :tournaments, :calc_system_id, :integer
  end

  def self.down
    drop_table "tournament_results"
    drop_table "calc_systems"
    remove_column :tournaments, :calc_system_id
  end
end
