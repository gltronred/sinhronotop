class EveryCityCanParticipateFlag < ActiveRecord::Migration
  def self.up
    add_column :tournaments, :every_city, :boolean
  end

  def self.down
    add_column :tournaments, :every_city
  end
end
