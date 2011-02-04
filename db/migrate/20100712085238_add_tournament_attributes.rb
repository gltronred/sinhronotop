class AddTournamentAttributes < ActiveRecord::Migration
  def self.up
    add_column :tournaments, :appeal_for_dismiss, :boolean
  end

  def self.down
    remove_column :tournaments, :appeal_for_dismiss
  end
end
