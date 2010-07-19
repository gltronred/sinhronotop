class CreateGames < ActiveRecord::Migration
  def self.up
    create_table :games do |t|
      t.string :name
      t.integer :num_questions
      t.date :begin
      t.date :end
      t.date :submit_disp_until
      t.date :submit_appeal_until
      t.date :submit_results_until
      t.integer :tournament_id

      t.timestamps
    end
  end

  def self.down
    drop_table :games
  end
end
