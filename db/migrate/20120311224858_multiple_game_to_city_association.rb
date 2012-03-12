class MultipleGameToCityAssociation < ActiveRecord::Migration
  def self.up
    remove_column :games, :city_id
    create_table "cities_games", :id => false, :force => true do |t|
      t.integer "city_id"
      t.integer "game_id"
    end    
  end

  def self.down
    add_column :games, :city_id, :integer
    drop_table "cities_games"    
  end
end
