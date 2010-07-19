class CreateResultitems < ActiveRecord::Migration
  def self.up
    create_table :resultitems do |t|
      t.integer :result_id
      t.integer :score
      t.integer :question_index
      t.timestamps
    end
  end

  def self.down
    drop_table :resultitems
  end
end
