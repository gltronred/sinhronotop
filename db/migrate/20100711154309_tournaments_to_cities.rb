class TournamentsToCities < ActiveRecord::Migration
  def self.up
    create_table :cities_tournaments, :id => false do |t|
      t.integer :city_id
      t.integer :tournament_id
    end
  end

  def self.down
    drop_table :cities_tournaments
  end
end
