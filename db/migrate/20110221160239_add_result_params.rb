class AddResultParams < ActiveRecord::Migration
  def self.up
    add_column :tournaments, :cap_name_required, :boolean
    add_column :results, :place_begin, :integer
    add_column :results, :place_end, :integer
    add_column :results, :cap_name, :string    
    
    Tournament.all.each{|tournament|tournament.cap_name_required=false; tournament.save}
  end

  def self.down
    remove_column :tournaments, :cap_name_required    
    remove_column :results, :place_begin
    remove_column :results, :place_end
    remove_column :results, :cap_name
  end
end
