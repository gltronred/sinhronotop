class AddSubmitFromFields < ActiveRecord::Migration
  def self.up
    add_column :games, :submit_disp_from, :date
    add_column :games, :submit_appeal_from, :date
    add_column :games, :submit_results_from, :date
  end

  def self.down
    remove_column :games, :submit_disp_from
    remove_column :games, :submit_appeal_from_from
    remove_column :games, :submit_results_from
  end
end
