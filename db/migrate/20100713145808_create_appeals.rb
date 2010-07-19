class CreateAppeals < ActiveRecord::Migration
  def self.up
    create_table :appeals do |t|
      t.integer :question_index
      t.string :answer
      t.string :goal
      t.string :argument
      t.integer :event_id

      t.timestamps
    end
  end

  def self.down
    drop_table :appeals
  end
end
