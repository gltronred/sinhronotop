class AddTeamIndexInResults < ActiveRecord::Migration
  def self.up
    add_column :results, :local_index, :integer
    
    Event.all.each do |event|
      event.results.sort_by {|r| [r.score, r.team.name] }.each_with_index do |result, i|
        result.local_index = i+1
        result.save
      end
    end
  end

  def self.down
    remove_column :results, :local_index
  end
end
