class AddPublishGameResultsFields < ActiveRecord::Migration
  def self.up
    add_column :games, :publish_disp, :boolean, :default => false
    add_column :games, :publish_appeal, :boolean, :default => false
    add_column :games, :publish_results, :boolean, :default => false
  end

  def self.down
    remove_column :games, :publish_disp
    remove_column :games, :publish_appeal
    remove_column :games, :publish_results
  end
end
