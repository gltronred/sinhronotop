class Resultitem < ActiveRecord::Base
  belongs_to :result
  validates_presence_of :question_index, :result_id, :score
  validates_inclusion_of :score, :in => [0, 1]  
end
