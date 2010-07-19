class CreateDisputeds < ActiveRecord::Migration
  def self.up
    create_table :disputeds do |t|
      t.integer :question_index
      t.string :answer
      t.integer :event_id

      t.timestamps
    end
  end

  def self.down
    drop_table :disputeds
  end
end
